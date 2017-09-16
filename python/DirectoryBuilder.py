#!/usr/bin/env python
import os
import shutil

class DirectoryBuilder:
        """
        Builds directories from list of files

	If for some reason you had a directory of nested files
	that got copied to another location, except the new location
	flattened all the files, then this script will rebuild those paths.
	You just need to know the new directory, and where they originated from.

	For example, if you had a directory that looked like the following:
	/test/file1
	/test/dir1
	/test/dir1/file2
	/test/dir1/file3

	And you, or a program copied these files to a new directory that looked like this:
	/test2/file1
	/test2/file2
	/test2/file3

	Then modifying the main section of this script with these parameters will cause it to
	rebuild those paths:
	
	files = DirectoryBuilder('/test2', '/test1')
	files.rename_files()

	I have surprisingly had a use case for this script a surprising amount of times.
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
        files = DirectoryBuilder('/test2', '/test1')
        files.rename_files()
