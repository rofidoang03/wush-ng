import subprocess
import re

# Jalankan airodump-ng dan simpan outputnya ke file
def run_airodump(output_file):
    command = f'airodump-ng -w {output_file} --output-format csv wlan0mon'
    subprocess.run(command, shell=True)

# Parse output file airodump-ng
def parse_airodump_output(file_path):
    with open(file_path, 'r') as file:
        lines = file.readlines()

    bssids_with_clients = set()
    bssid_regex = re.compile(r'(([0-9A-Fa-f]{2}:){5}[0-9A-Fa-f]{2})')

    # Flag to check if we are in the clients section
    clients_section = False

    for line in lines:
        if line.startswith("Station MAC"):
            clients_section = True
            continue

        if clients_section:
            parts = line.split(',')
            if len(parts) > 5:
                bssid = parts[5].strip()
                if bssid_regex.match(bssid):
                    bssids_with_clients.add(bssid)

    return bssids_with_clients

# Main function
def main():
    output_file = 'airodump_output.csv'
    run_airodump(output_file)

    bssids_with_clients = parse_airodump_output(output_file + '-01.csv')
    if bssids_with_clients:
        print("BSSID with clients connected:")
        for bssid in bssids_with_clients:
            print(bssid)
    else:
        print("No BSSID with clients found.")

if __name__ == '__main__':
    main()
