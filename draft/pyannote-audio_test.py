# ~/MEGAsync/D_Filipe_Zabala/pacotes/voice/draft/pyannote-audio_test.py
# 
# wget https://github.com/filipezabala/voiceAudios/raw/main/wav/sherlock0.wav
# wget https://github.com/filipezabala/voiceAudios/raw/main/wav/sherlock1.wav

from pyannote.audio import Pipeline
print(Pipeline)
pipeline = Pipeline.from_pretrained("pyannote/speaker-diarization",
                                    use_auth_token="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")

# apply the pipeline to an audio file
diarization = pipeline("sherlock0.wav")

# dump the diarization output to disk using RTTM format
with open("sherlock0.rttm", "w") as rttm:
    diarization.write_rttm(rttm)
