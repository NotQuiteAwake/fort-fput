project('fput', 'fortran',
  license: 'MIT')

# compiler setups
fc = meson.get_compiler('fortran')
if fc.get_id() == 'gcc'
  add_global_arguments('-fbounds-check', language: 'fortran')
endif

args = fc.first_supported_argument(['-ffree-form', 'free', '/free'])
assert(args != [], 'no available arguments')

# source files
srcs = []
subdir('src')

ex = executable('fput', srcs, fortran_args: args)
test('fput', ex)

