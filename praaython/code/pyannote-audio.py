# https://github.com/pyannote/pyannote-audio-hub
# $ pip3 install torch torchvision
# $ git clone https://github.com/pyannote/pyannote-audio.git
# $ cd pyannote-audio
# $ git checkout develop
# $ pip3 install .
# $ brew update && brew upgrade
# $ pip3 install librosa 
# $ pip3 install tensorboard

# load pipeline
import torch
pipeline = torch.hub.load('pyannote/pyannote-audio', 'dia')

# apply diarization pipeline on your audio file
diarization = pipeline({'audio': '/Users/filipezabala/Desktop/FOLDER01/ZOOM0031.WAV'})

# dump result to disk using RTTM format
with open('/Users/filipezabala/Desktop/FOLDER01/ZOOM0031.rttm', 'w') as f:
    diarization.write_rttm(f)
  
# iterate over speech turns
for turn, _, speaker in diarization.itertracks(yield_label=True):
    print(f'Speaker "{speaker}" speaks between t={turn.start:.1f}s and t={turn.end:.1f}s.')
