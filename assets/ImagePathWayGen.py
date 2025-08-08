import os
import json

pathway = 'images/people'
output_file = 'image_paths.json'

file_paths = []

if os.path.exists(pathway):
    file_names = os.listdir(pathway)
    
    for name in file_names:
        print(f'assets/images/{name}')
        formatted_path = f'assets/images/people/{name}'
        file_paths.append(formatted_path)

data = {
    "images": file_paths
}

with open(output_file, 'w') as f:
    json.dump(data, f, indent=2)
    
print(f"Successfully created '{output_file}' with {len(file_paths)} image paths.")

    