use anyhow::{anyhow, Result};
use bytes::{Buf, Bytes};
use flate2::bufread::GzDecoder;
use regex::Regex;
use reqwest::RequestBuilder;
use serde::Deserialize;
use std::io::Cursor;
use std::string::ToString;
use tar::Archive;

const API_ROOT: &str = "https://registry-1.docker.io/v2";

pub struct RegistryClient {
    client: reqwest::Client,
    token: Option<String>,
}

impl RegistryClient {
    pub fn new() -> Self {
        RegistryClient {
            client: reqwest::Client::new(),
            token: None,
        }
    }

    pub async fn pull(&mut self, image: &String, target_dir: &str) -> Result<()> {
        let image: Image = image.clone().into();
        let manifest = self.get_manifest(&image).await?;

        for layer in manifest.layers {
            let layer_bytes = self
                .client
                .get(format!(
                    "{}/library/{}/blobs/{}",
                    API_ROOT, image.repository, layer.digest
                ))
                // Token was valid for the manifest fetch, assume it's present and valid here.
                .bearer_auth(self.token.as_ref().unwrap())
                .send()
                .await?
                .bytes()
                .await?;

            unpack_layer(layer_bytes, target_dir)?;
        }

        Ok(())
    }

    async fn get_manifest(&mut self, image: &Image) -> Result<ManifestV2> {
        let manifest_request = self.new_manifest_request(image);

        let mut get_manifest = manifest_request.send().await?;

        if get_manifest.status().as_u16() == 401 {
            let auth_params: AuthParams = get_manifest
                .headers()
                .get("WWW-Authenticate")
                .unwrap()
                .to_str()?
                .into();

            self.authenticate(&auth_params).await?;

            // Retry the request with the token
            get_manifest = self.new_manifest_request(image).send().await?;
        }

        if get_manifest.status().is_success() {
            let res_bosy = get_manifest.text().await?;
            let res = res_bosy.as_str();
            Ok(serde_json::from_str(res)?)
        } else {
            Err(anyhow!(
                "error fetching manifest - {}",
                get_manifest.text().await?.as_str()
            ))
        }
    }

    fn new_manifest_request(&mut self, image: &Image) -> RequestBuilder {
        let mut request_builder = self
            .client
            .get(format!(
                "{}/library/{}/manifests/{}",
                API_ROOT, image.repository, image.reference
            ))
            .header(
                "Accept",
                "application/vnd.docker.distribution.manifest.v2+json",
            );

        if let Some(token) = &self.token {
            request_builder = request_builder.bearer_auth(token);
        }
        request_builder
    }

    async fn authenticate(&mut self, authenticate_params: &AuthParams) -> Result<()> {
        let response = self
            .client
            .get(&authenticate_params.realm)
            .query(&[
                ("service", &authenticate_params.service),
                ("scope", &authenticate_params.scope),
            ])
            .send()
            .await?;

        let token_response: TokenResponse = serde_json::from_str(response.text().await?.as_ref())?;

        self.token = Some(token_response.token);

        Ok(())
    }
}

fn unpack_layer(layer_bytes: Bytes, target_dir: &str) -> Result<()> {
    let tar = GzDecoder::new(Cursor::new(layer_bytes).reader());
    let mut archive = Archive::new(tar);
    archive.unpack(target_dir)?;

    Ok(())
}

#[derive(Debug)]
struct AuthParams {
    realm: String,
    service: String,
    scope: String,
}

impl From<&str> for AuthParams {
    fn from(www_authenticate: &str) -> Self {
        let authenticate_params_regex = Regex::new(r#"realm="(.*)",service="(.*)",scope="(.*)""#)
            .expect("invalid regular expression");
        match authenticate_params_regex.captures(www_authenticate) {
            Some(matches) => AuthParams {
                realm: matches.get(1).unwrap().as_str().to_string(),
                service: matches.get(2).unwrap().as_str().to_string(),
                scope: matches.get(3).unwrap().as_str().to_string(),
            },
            None => {
                panic!(
                    "Unexpected format for the WWW-Authenticate header - {}",
                    www_authenticate
                );
            }
        }
    }
}

struct Image {
    repository: String,
    reference: String,
}

impl From<String> for Image {
    fn from(raw: String) -> Self {
        let mut parts = raw.split(":");
        Image {
            repository: parts.next().unwrap().to_string(),
            reference: parts.next().unwrap_or("latest").to_string(),
        }
    }
}

#[derive(Deserialize)]
struct TokenResponse {
    token: String,
}

#[derive(Deserialize)]
struct ManifestV2 {
    layers: Vec<Layer>,
}

#[derive(Deserialize)]
struct Layer {
    digest: String,
}
