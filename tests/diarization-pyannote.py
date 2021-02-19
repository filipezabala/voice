# from ~/D_Filipe_Zabala/thesis/code/praaython/pyannote-audio_v3.py
# https://github.com/pyannote/pyannote-audio
# https://github.com/pyannote/pyannote-audio-hub, use virtual environment
# https://docs.conda.io/en/latest/miniconda.html

# $ wget -r -np -k https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-x86_64.sh
# $ bash Miniconda3-latest-MacOSX-x86_64.sh
# $ conda create -n py38phdz python=3.8
# $ conda init bash
# $ conda activate py38phdz
# $ pip install -r ~/Dropbox/D_Filipe_Zabala/thesis/code/praaython/requirements_pyannote-audio.txt
# $ pip install -r librosa
# $ pip3 install pyannote.audio==1.1.1
# $ cd /Users/filipezabala/miniconda3
# $ conda init

# load packages
import os
import re
import sys
import torch
import pandas

# def run():
#     torch.multiprocessing.freeze_support()
#     print('loop')
#
# if __name__ == '__main__':
#     run()

# working directory
os.chdir(sys.argv[1])
# os.chdir('/Users/filipezabala/Dropbox/D_Filipe_Zabala/audios/testes/')
# os.chdir('/Users/filipezabala/Dropbox/D_Filipe_Zabala/audios/coorte/wav/')

# # setting options
# pandas.set_option('display.max_rows', None)
# pandas.set_option('display.max_columns', None)
# pandas.set_option('display.width', None)
# pandas.set_option('display.max_colwidth', None)
# dfs = []

# listing directory files
dirlist = sorted(os.listdir())
n_dir = len(dirlist)

# applying diarization
pipeline = torch.hub.load('pyannote/pyannote-audio', 'dia')
for file in dirlist:
    if file.endswith('.WAV') and __name__ == '__main__':
        file_list = os.path.join(os.getcwd(), file)
        diarization = pipeline({'audio': file_list})
        file_name = re.findall('(.+?).WAV', file)
        with open(['./' + file_name[0] + '.rttm'][0], 'w') as f:
            diarization.write_rttm(f)
        # for turn, _, speaker in diarization.itertracks(yield_label=True):
        #     print(f'Speaker "{speaker}" speaks between t={turn.start:.1f}s and t={turn.end:.1f}s.')
