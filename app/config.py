import os
from pathlib import Path
from dotenv import load_dotenv

def load_config():
    load_dotenv(Path(__file__).resolve().parent.parent / ".env")
    return {
        "MYSQL_HOST": os.getenv("MYSQL_HOST", "127.0.0.1"),
        "MYSQL_PORT": int(os.getenv("MYSQL_PORT", "3306")),
        "MYSQL_USER": os.getenv("MYSQL_USER", "root"),
        "MYSQL_PASSWORD": os.getenv("MYSQL_PASSWORD", ""),
        "MYSQL_DATABASE": os.getenv("MYSQL_DATABASE", "kindergarten_lab3"),
        "MAX_CONTENT_LENGTH": 1024 * 1024,
    }
