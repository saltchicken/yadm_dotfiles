from ollama_query import ollama_query
import sys
import argparse
from dotenv import load_dotenv
import os

# Load environment variables from .env
load_dotenv()

# Set up argument parser
parser = argparse.ArgumentParser(description='Query Ollama model')
parser.add_argument('prompt', nargs='+', help='The prompt to send to the model')
parser.add_argument('-s', '--system', help='System message to use')

# Parse known args to avoid errors with any additional arguments
args, unknown = parser.parse_known_args()

# Get values from command line args, .env, or use defaults
model = os.getenv("OLLAMA_MODEL", "hf.co/unsloth/Devstral-Small-2507-GGUF:UD-Q4_K_XL")
system_message = args.system
host = os.getenv("OLLAMA_HOST", "localhost")

# Join prompt arguments into a single string
prompt = " ".join(args.prompt)

response, debug_string = ollama_query(model, prompt, system_message, host)
print(response)
