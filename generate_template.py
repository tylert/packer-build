#!/usr/bin/env python

from os import getcwd, listdir, makedirs, path
from json import dumps, load
from codecs import open as copen

import click
from ruamel.yaml import YAML
from jinja2 import Environment, FileSystemLoader, TemplateNotFound
from six import iteritems


YAML_EXTENSIONS = ('yml', 'yaml')

# Packer is more picky about what keys it allows in templates starting in
# 1.4.0.  See https://github.com/hashicorp/packer/issues/7544 for details.  The
# list found at http://packer.io/docs/templates/index.html should be consulted
# from time-to-time

PACKER_TEMPLATE_KEYS = ('builders', 'description', 'min_packer_version',
                        'post-processors', 'provisioners', 'variables')


def get_os_names():
    '''
    '''

    source_path = path.join(path.dirname(path.abspath(__file__)), 'source')
    os_names = []
    os_names.extend(listdir(source_path))
    return sorted(os_names)


def get_os_versions(os_name):
    '''
    '''

    os_versions = path.join(path.dirname(path.abspath(__file__)), 'source',
                            os_name)
    return listdir(os_versions)


def get_os_templates(os_name, os_version):
    '''
    '''

    os_templates = path.join(path.dirname(path.abspath(__file__)), 'source',
                             os_name, os_version)
    return [path.splitext(file)[0] for file in listdir(os_templates)
            if file.endswith(YAML_EXTENSIONS)]


def check_os_version(ctx, param, value):
    '''
    '''

    os_name = ctx.params.get('os_name', None)
    if os_name == 'all':
        return 'all'
    if not os_name:
        fail(ctx, 'ERROR --os_name is required if --os_version is specified')

    try:
        os_versions = get_os_versions(os_name)
    except OSError as e:
        fail(ctx, 'ERROR Could not find templates for {}: {}'.format(os_name,
                                                                     str(e)))

    if value == 'all':
        return 'all'
    elif value not in os_versions:
        fail(ctx, 'ERROR {} is not a supported version of {}. Valid version(s): {}'.format(
            value, os_name, ', '.join(os_versions) + '.'))
    return value


def log(ctx, msg):
    '''
    '''

    if ctx.params.get('verbose', False):
        print(msg)


def fail(ctx, msg):
    '''
    '''

    print(msg)
    ctx.exit()


def get_base_variables(ctx, base_dir, os_name, os_template, os_version):
    '''
    '''

    template_file = '{}.yaml'.format(os_template)

    yaml = YAML()
    yaml.allow_duplicate_keys = True

    with open(path.join(base_dir, os_name, os_version, template_file), 'r') as f:
        return yaml.load(f)


def get_override_variables(ctx, var_file):
    '''
    '''

    with open(var_file, 'r') as f:
        return load(f)


def build_templates(ctx, base_dir, os_name, os_template, os_version, var_file):
    '''
    '''

    # Validate the desired working directory and change if required
    if not path.isdir(base_dir):
        fail(ctx, 'ERROR Cannot use base_dir of {} as it is not a directory'.format(
             base_dir))

    # Load the desired template variables
    config_dict = get_base_variables(ctx, base_dir, os_name, os_template,
                                     os_version)

    # Drop any keys that aren't in the list of allowed Packer template keys
    # Allow root level keys that start with underscore
    for key in list(config_dict.keys()):
        if key.lower() not in PACKER_TEMPLATE_KEYS:
            del config_dict[key]

    # Attempt to bring in any variable overrides
    override_dict = {}
    if var_file:
        override_dict = get_override_variables(ctx, var_file)
    config_dict['variables'].update(override_dict)

    # Create the target directory if it does not exist
    target_dir = path.join(getcwd(), 'template', os_name, os_version)
    if path.isfile(target_dir):
        fail(ctx, 'ERROR The target directory ({}) already exists, but is a file. Aborting'.format(
             target_dir))
    if not path.isdir(target_dir):
        makedirs(target_dir)

    # Set up the template engine
    renderer = Environment(loader=FileSystemLoader(path.join(base_dir, os_name,
                                                             os_version)))

    # Render the destination files (assume everything is a template)
    for file in listdir(path.join(base_dir, os_name, os_version)):
        if file.endswith(YAML_EXTENSIONS):
            continue

        try:
            ginger = renderer.get_template(file)
        except TemplateNotFound:
            fail(ctx, 'ERROR Missing template file {}'.format(file))
        except UnicodeDecodeError:
            fail(ctx, 'ERROR Binary file {} cannot be templated'.format(file))

        target = path.join(target_dir, file)
        log(ctx, 'Writing file: {}'.format(target))
        with copen(target, 'w', 'utf-8') as f:
            f.write(ginger.render(config_dict['variables']))

    # Render the destination Packer JSON template
    target_json_path = path.join(target_dir, os_template + '.json')
    log(ctx, 'Writing template: {}'.format(target_json_path))
    with copen(target_json_path, 'w', 'utf-8') as f:
        f.write(dumps(config_dict, sort_keys=True, indent=2,
                      ensure_ascii=False, separators=(',', ': ')))


@click.command()
@click.pass_context
@click.option('--base_dir',
              help='The base directory from which source files will be read.  Default "source".',
              default=path.join(getcwd(), 'source'),
              required=False)
@click.option('--os_name',
              help='The operating system name of the template to create.  Example "debian" or "all".  Default "all"',
              default='all',
              required=False)
# type=click.Choice(get_os_names()))
@click.option('--os_template',
              help='The name of the YAML template file to build from.  Example "base-uefi" or "all".  Default "all".',
              default='all',
              required=False)
@click.option('--os_version',
              help='The version of the operating system template to create.  Example "11_bullseye" or "all".  Default "all".',
              default='all',
              required=False)
# callback=check_os_version)
@click.option('--var_file',
              help='Extra variables JSON file to be used for template overrides before Packer runs.',
              default=False,
              required=False)
@click.option('--verbose',
              help='Enable verbose logging',
              default=False,
              is_flag=True)
def main(ctx, base_dir, os_name, os_template, os_version, var_file, verbose):
    '''
    '''

    for a_name in get_os_names() if os_name == 'all' else [os_name]:
        for a_version in get_os_versions(a_name) if os_version == 'all' else [os_version]:
            for a_template in get_os_templates(a_name, a_version) if os_template == 'all' else [os_template]:
                print('Creating {} templates for {} version {}'.format(
                      a_template, a_name, a_version))
                build_templates(ctx=ctx, base_dir=base_dir, os_name=a_name,
                                os_template=a_template, os_version=a_version,
                                var_file=var_file)


if __name__ == '__main__':
    main()
