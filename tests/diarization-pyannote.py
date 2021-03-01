"""
from ~/D_Filipe_Zabala/thesis/code/praaython/pyannote-audio_v3.py and pyannote-audio_v4.py
https://github.com/pyannote/pyannote-audio
https://github.com/pyannote/pyannote-audio-hub, use virtual environment
https://docs.conda.io/en/latest/miniconda.html

# Linux
$ wget -r -np -k https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
$ cd repo.anaconda.com//miniconda
$ bash Miniconda3-latest-Linux-x86_64.sh
$ conda create -n py38linux python=3.8
$ conda init bash
$ conda activate py38linux
$ pip install -r ~/Dropbox/D_Filipe_Zabala/thesis/code/praaython/requirements_pyannote-audio.txt
$ pip3 install pyannote.audio==1.1.1
$ conda init

# Mac
$ wget -r -np -k https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-x86_64.sh
$ bash Miniconda3-latest-MacOSX-x86_64.sh
$ conda create -n py38phdz python=3.8
$ conda init bash
$ conda activate py38phdz
$ pip install -r ~/Dropbox/D_Filipe_Zabala/thesis/code/praaython/requirements_pyannote-audio.txt
$ pip install -r librosa
$ pip3 install pyannote.audio==1.1.1
$ cd /Users/filipezabala/miniconda3
$ conda init
"""
# load packages

import os
import sys
import torch
import argparse
import warnings

# ignorar warnings
warnings.filterwarnings('ignore')


def list_files(pathfrom: str, filter: str = '.wav'):
    # """
    # Lists all files in a directory and subdirectories.
    #
    # :param pathfrom: directory from which you want to search for files.
    # :param filter: extension used to filter files. Default: '.wav'.
    # :return: tuple containing the full path to the file and the file name. Ex: ('/home', 'file.wav')
    # """
    for root, dirs, files in os.walk(pathfrom):
        for f in files:
            if f.lower().endswith(filter):
                yield root, f


def main():
    # """
    # An main() function is used as good practice in python, which concentrates calls to python modules,
    # mainly those that will be invoked by command line or by other programs.
    #
    # The function main() must be called within a special if:
    #
    # if __name__ == '__main__':
    #     main()
    #
    # This ensures that the main() function will be called only when the code is executed as a module
    # from command line. Thus, when importing the current file to be used as a library in other code,
    # the main() function is not executed since the if condition will not be satisfied.
    # However, it will be available for use in the code that imported the module.
    #
    # :return: None
    # """

    parser = argparse.ArgumentParser(prog='pyannote-audio')
    parser.add_argument('--pathfrom', help='Path from (reading .wav)', action='store', required=True)
    parser.add_argument('--pathto', help='Path to (writing .rttm)', action='store', required=True)

    args = parser.parse_args()

    pipeline = torch.hub.load('pyannote/pyannote-audio', 'dia')
    i=0
    for fileroot, filename in list_files(args.pathfrom):
        diarization = pipeline({'audio': os.path.join(fileroot, filename)})
        filename_base, filename_ext = os.path.splitext(filename)
        filename_out = '{}.rttm'.format(filename_base)
        with open(os.path.join(args.pathto, filename_out), 'w') as f:
            diarization.write_rttm(f)
        i=i+1
        print(i)


if __name__ == '__main__':
    """
    Do not put any other code here.
    """
    main()




# OLD
# # working directory
# os.chdir(sys.argv[1])

# # listing directory files
# dirlist = sorted(os.listdir())
# n_dir = len(dirlist)
#
# # applying diarization
# for file in dirlist:
#     if file.endswith('.WAV') and __name__ == '__main__':
#         torch.multiprocessing.freeze_support()
#         pipeline = torch.hub.load('pyannote/pyannote-audio', 'dia')
#         file_list = os.path.join(os.getcwd(), file)
#         diarization = pipeline({'audio': file_list})
#         file_name = re.findall('(.+?).WAV', file)
#         with open(['./' + file_name[0] + '.rttm'][0], 'w') as f:
#             diarization.write_rttm(f)
#         # for turn, _, speaker in diarization.itertracks(yield_label=True):
#         #     print(f'Speaker "{speaker}" speaks between t={turn.start:.1f}s and t={turn.end:.1f}s.')
