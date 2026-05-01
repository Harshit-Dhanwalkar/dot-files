#!/usr/bin/env python3
import json
import time
print(json.dumps({
    "text": f"TEST {int(time.time()) % 60}",
    "class": "test"
}))
