# from ~/D_Filipe_Zabala/thesis/code/praaython/pyannote-audio_v3.py and pyannote-audio_v4.py
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
import sys
import torch
import argparse
import warnings

# ignorar warnings
warnings.filterwarnings('ignore')

# arquivos
for root, dirs, files in os.walk(sys.argv[1]):
    for f in files:
        if f.lower().endswith(sys.argv[2]):
            yield root, f


def main():
    """
    Utiliza-se como boa prática no python uma função main que concentra as chamada para módulos python, principalmente
    aqueles que serão invocados por linha de comando ou por outros programas.

    A função main() deve ser chamada dentro de um if especial:

    if __name__ == '__main__':
        main()

    Isso garante que a função main() será chamada apenas quando o código é executado como um módulo por linha de comando.
    Assim, ao importar o arquivo atual para ser utlizado como biblioteca em outro código, a função main não é executada
    pois a condição do if não será satisfeita. Entranto, ela estará disponível para uso no código que realizou a importação
    do módulo.

    :return: None
    """

    parser = argparse.ArgumentParser(prog='pyannote-audio')
    parser.add_argument('--path', help='Caminho para os arquivos', action='store', required=True)
    args = parser.parse_args()

    pipeline = torch.hub.load('pyannote/pyannote-audio', 'dia')
    for fileroot, filename in list_files(args.path):
        diarization = pipeline({'audio': os.path.join(fileroot, filename)})
        filename_base, filename_ext = os.path.splitext(filename)
        filename_out = '{}.rttm'.format(filename_base)
        with open(os.path.join(fileroot, filename_out), 'w') as f:
            diarization.write_rttm(f)


if __name__ == '__main__':
    """
    Não colocar nenhum outro código aqui.
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
