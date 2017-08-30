#!/usr/local/bin/python3.6
import os
import shutil

class DirectoryBuilder:
        """
        Builds directories from list of files
        """
        # Constants
        dirpath = 0
        dirnames = 1
        filenames = 2
        failed_files = list()

        def __init__(self, raw_filedir, original_filedir):
                self.raw_filedir = raw_filedir
                self.original_filedir = original_filedir
                self.incorrect_files = os.listdir(self.raw_filedir)
                self.failed_log = '/tmp/failed_directory_builder.txt'

        def rename_files(self):
                for _file in os.walk(self.original_filedir):
                        for filename in _file[DirectoryBuilder.filenames]:
                                try:
                                        if filename in self.incorrect_files:
                                                old_filename = '{0}/{1}'.format(self.raw_filedir, filename)
                                                new_filedir = '{0}/{1}'.format(self.raw_filedir,
                                                                               _file[DirectoryBuilder.dirpath])
                                                new_filename = '{0}/{1}'.format(new_filedir,
                                                                                filename)
                                                print('Renaming {0} to {1}'.format(old_filename, new_filename))
                                                if not os.path.exists(new_filedir):
                                                        os.makedirs(new_filedir)
                                                shutil.move(old_filename, new_filename)
                                except OSError as e:
                                        print(e)
                                        DirectoryBuilder.failed_files.append(filename)

                with open(self.failed_log, 'w') as f:
                        for filename in DirectoryBuilder.failed_files:
                                f.write('{0}\n'.format(filename))

if __name__ == '__main__':
        files = DirectoryBuilder('/mnt/ssd-sdb1/PyPi-Export-2017-08-24_02:44', '/home/bandersnatch')
        files.rename_files()
