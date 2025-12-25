from fastapi import FastAPI, UploadFile, File, Form
import uvicorn
import shutil
import os
import speech_recognition as sr
from fuzzywuzzy import fuzz # Logic to compare strings

app = FastAPI()

UPLOAD_DIR = "uploaded_audio"
os.makedirs(UPLOAD_DIR, exist_ok=True)

@app.post("/analyze-audio")
async def analyze_audio(
    file: UploadFile = File(...), 
    target_word: str = Form(...) # We now receive the target word!
):
    # 1. Save File
    file_location = f"{UPLOAD_DIR}/{file.filename}"
    with open(file_location, "wb") as buffer:
        shutil.copyfileobj(file.file, buffer)
    
    print(f"🎧 Analyzing audio for target: '{target_word}'")

    # 2. Transcribe
    recognizer = sr.Recognizer()
    text_detected = ""
    
    try:
        with sr.AudioFile(file_location) as source:
            audio_data = recognizer.record(source)
            # Google Speech-to-Text (Requires Internet)
            text_detected = recognizer.recognize_google(audio_data)
            print(f"🗣️ User said: '{text_detected}'")
            
    except sr.UnknownValueError:
        text_detected = "..."
    except Exception as e:
        print(f"Error: {e}")
        text_detected = "Error"

    # 3. REAL SCORING LOGIC 🧠
    if text_detected == "..." or text_detected == "Error":
        score = 0
        feedback = "I couldn't hear you. Please speak louder!"
    else:
        # Compare what user said vs target word (0-100 score)
        score = fuzz.ratio(text_detected.lower(), target_word.lower())
        
        if score > 80:
            feedback = "Perfect! You sound like a pro."
        elif score > 50:
            feedback = "Good try! You are almost there."
        else:
            feedback = "Not quite. Try identifying the sounds."

    return {
        "status": "success",
        "text_detected": text_detected,
        "pronunciation_score": score,
        "feedback": feedback
    }

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)