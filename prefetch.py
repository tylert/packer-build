#!/usr/bin/env python

# Packer can download ISO files, however, it insists on renaming them when it
# does so.  Packer will also not bother redownloading ISOs if they are already
# in its local packer_cache directory.  This script attempts to pre-popluate
# this cache but rather than rename the original ISO files, it simply makes a
# symlink to it instead.

# https://github.com/mitchellh/packer/issues/1826


import sys

if sys.version_info[:1] == 3:
    from urllib.request import urlretrieve
else:
    from urllib import urlretrieve

import hashlib
import os
import argparse
import json
import glob


local_directory = os.getenv('PACKER_CACHE_DIR', 'packer_cache')

description = '''

This script will attempt to download specified image files.

'''


def hash_file(directory, filename, blocksize=2**20, hash_method='sha512'):
    '''Calculate the checksum of a file using the specified method.'''

    if hash_method == 'sha256':
        file_hash = hashlib.sha256()
    else:
        file_hash = hashlib.sha512()

    if os.path.isfile(os.path.join(directory, filename)) and \
            os.access(os.path.join(directory, filename), os.R_OK):

        with open(os.path.join(directory, filename), 'rb') as filehandle:
            while True:
                block = filehandle.read(blocksize)
                if not block:
                    break
                file_hash.update(block)

    return file_hash.hexdigest()


def reporthook(block_count, block_size, total_size):
    '''Display a percentage counter for the number of blocks to download.'''

    percentage = float(block_count * block_size) / total_size * 100

    sys.stdout.write('\r{percentage:.1f}%'.format(percentage=percentage))
    sys.stdout.flush()


def remove_symlinks(local_directory=local_directory):
    '''Remove all symlinks found in the specified local_directory.'''

    for filename in glob.glob(local_directory + os.sep + '*'):

        if os.path.islink(filename):
            try:
                os.unlink(filename)
            except OSError:
                print('Failed to remove symlink {filename}.'.format(filename=filename))
            else:
                print('Removed symlink {filename}.'.format(filename=filename))


def create_symlink(iso_url, iso_filename, local_directory=local_directory):
    '''Create URL hash symlink for file found in local_directory'''

    # packer.io expects ISO files have been renamed to their SHA256 URLs.
    url_hash = hashlib.sha256(iso_url).hexdigest() + '.iso'

    if os.path.exists(os.path.join(local_directory, url_hash)):
        print('Found {url_hash}.'.format(url_hash=url_hash))
    else:
        try:
            os.symlink(iso_filename, os.path.join(local_directory, url_hash))
        except OSError:
            print('Failed to create {url_hash}.'.format(url_hash=url_hash))
        else:
            print('Created {url_hash}.'.format(url_hash=url_hash))


if __name__ == '__main__':

    parser = argparse.ArgumentParser(description=description)

    parser.add_argument('prefetch_file', help='List of image files to fetch')

    args = parser.parse_args()

    with open(args.prefetch_file, 'r') as filehandle:
        temp_dict = json.load(filehandle)

    # Remove all symlinks here since they are probably ones we made earlier.
    #remove_symlinks(local_directory)

    for entry in temp_dict['images']:

        iso_filename = entry['iso_filename']
        iso_url = entry['iso_url']
        iso_checksum = entry['iso_checksum']
        iso_checksum_type = entry['iso_checksum_type']
        iso_symlink = entry['iso_symlink']

        #index = iso_url.rfind('/')
        #image_file = iso_url[index + 1:]

        calculated_hash = hash_file(directory=local_directory,
            filename=iso_filename, hash_method=iso_checksum_type)

        if calculated_hash != iso_checksum:
            print('Prefetching {iso_filename}.'.format(iso_filename=iso_filename))
            urlretrieve(iso_url, os.path.join(local_directory, iso_filename),
                reporthook)
            print('')
        else:
            print('Already have {iso_filename}.'.format(iso_filename=iso_filename))

        if iso_symlink is False:
            continue

        create_symlink(iso_url=iso_url, iso_filename=iso_filename,
            local_directory=local_directory)
