from flask import Flask, request, jsonify
import base64
from Crypto.Cipher import AES
from Crypto.Util.Padding import unpad
from selenium import webdriver
from selenium.webdriver.chrome.options import Options
import time
import os

app = Flask(__name__)
SECRET_KEY = b"16byteslongkey1!"  # Your secret key

def decrypt_data(encrypted_data, key):
    cipher = AES.new(key, AES.MODE_ECB)
    decoded_data = base64.urlsafe_b64decode(encrypted_data)
    return unpad(cipher.decrypt(decoded_data), AES.block_size).decode()


@app.route("/relay", methods=["GET"])
def relay():
    encrypted_data = request.args.get("data")
    if not encrypted_data:
        return jsonify({"error": "Invalid request"}), 400

    try:
        target_url = decrypt_data(encrypted_data, SECRET_KEY)
        print(f"[+] Decrypted request: {target_url}")

        # Configure headless Chrome
        chrome_options = Options()
        chrome_options.binary_location = "/tmp/chrome/chrome"  # Add this line
        chrome_options.add_argument("--headless")
        chrome_options.add_argument("--disable-gpu")
        chrome_options.add_argument("--no-sandbox")
        chrome_options.add_argument("--disable-dev-shm-usage")
        chrome_options.add_argument("user-agent=Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36")

        driver = webdriver.Chrome(
            executable_path="/tmp/chrome/chromedriver",
            options=chrome_options
        )
        driver.get(target_url)
        time.sleep(3)
        content = driver.page_source
        driver.quit()

        return jsonify({"fetched_url": target_url, "content": content})

    except Exception as e:
        return jsonify({"error": str(e)}), 500
if __name__ == "__main__":
    port = int(os.environ.get("PORT", 8080))
    app.run(host='0.0.0.0', port=port)
