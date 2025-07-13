from ollama_query import ollama_query
import sys


model = "hf.co/unsloth/Devstral-Small-2507-GGUF:UD-Q4_K_XL"
# system_message = "You are a helpful assistant."
system_message = "Talk like a pirate"
host = "main"

if len(sys.argv) > 1:
    prompt = " ".join(sys.argv[1:])
else:
    print("No prompt provided. Exiting.")
    exit()

response, debug_string = ollama_query(model, prompt, system_message, host)
print(response)
