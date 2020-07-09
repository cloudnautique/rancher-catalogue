from distutils.core import setup

setup(
    name='Rancher Catalog YAML Integration Tests',
    version='0.1',
    packages=[
      'core',
    ],
    license='ASL 2.0',
    tests_require=[
        "more-itertools<6.0.0",
    ],
)
