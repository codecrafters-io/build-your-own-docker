The entry point for your Docker implementation is in `app/main.py`.

Study and uncomment the relevant code: 

```python
# Uncomment this block to pass the first stage

command = sys.argv[3]
args = sys.argv[4:]

completed_process = subprocess.run([command, *args], capture_output=True)
print(completed_process.stdout.decode("utf-8"))
```

Push your changes to pass the first stage:

```
git add .
git commit -m "pass 1st stage" # any msg
git push origin master
```
