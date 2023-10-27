# DO NOT EDIT: Generated by generate_workspace.py
"""Defines third-party bazel repos for Python packages fetched with pip."""

load(
    "//third_party:repo.bzl",
    "third_party_python_package",
)
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")

def repo():
    repo_pypa_absl_py()
    repo_pypa_alabaster()
    repo_pypa_annotated_types()
    repo_pypa_appdirs()
    repo_pypa_appnope()
    repo_pypa_asttokens()
    repo_pypa_attrs()
    repo_pypa_babel()
    repo_pypa_backcall()
    repo_pypa_blinker()
    repo_pypa_certifi()
    repo_pypa_charset_normalizer()
    repo_pypa_click()
    repo_pypa_cloudpickle()
    repo_pypa_colorama()
    repo_pypa_crc32c()
    repo_pypa_decorator()
    repo_pypa_docutils()
    repo_pypa_exceptiongroup()
    repo_pypa_executing()
    repo_pypa_flask()
    repo_pypa_googleapis_common_protos()
    repo_pypa_grpcio()
    repo_pypa_idna()
    repo_pypa_imagesize()
    repo_pypa_importlib_metadata()
    repo_pypa_iniconfig()
    repo_pypa_ipython()
    repo_pypa_itsdangerous()
    repo_pypa_jedi()
    repo_pypa_jinja2()
    repo_pypa_jsonschema()
    repo_pypa_jsonschema_specifications()
    repo_pypa_markupsafe()
    repo_pypa_matplotlib_inline()
    repo_pypa_ml_dtypes()
    repo_pypa_numpy()
    repo_pypa_packaging()
    repo_pypa_parso()
    repo_pypa_pexpect()
    repo_pypa_pickleshare()
    repo_pypa_platformdirs()
    repo_pypa_pluggy()
    repo_pypa_prompt_toolkit()
    repo_pypa_protobuf()
    repo_pypa_ptyprocess()
    repo_pypa_pure_eval()
    repo_pypa_pydantic()
    repo_pypa_pydantic_core()
    repo_pypa_pydantic_extra_types()
    repo_pypa_pygments()
    repo_pypa_pytest()
    repo_pypa_pytest_asyncio()
    repo_pypa_pyyaml()
    repo_pypa_referencing()
    repo_pypa_requests()
    repo_pypa_requests_toolbelt()
    repo_pypa_rpds_py()
    repo_pypa_scalpl()
    repo_pypa_six()
    repo_pypa_snowballstemmer()
    repo_pypa_sphinx()
    repo_pypa_sphinx_immaterial()
    repo_pypa_sphinxcontrib_applehelp()
    repo_pypa_sphinxcontrib_devhelp()
    repo_pypa_sphinxcontrib_htmlhelp()
    repo_pypa_sphinxcontrib_jsmath()
    repo_pypa_sphinxcontrib_qthelp()
    repo_pypa_sphinxcontrib_serializinghtml()
    repo_pypa_stack_data()
    repo_pypa_tomli()
    repo_pypa_traitlets()
    repo_pypa_typing_extensions()
    repo_pypa_urllib3()
    repo_pypa_wcwidth()
    repo_pypa_werkzeug()
    repo_pypa_yapf()
    repo_pypa_zipp()

def repo_pypa_absl_py():
    maybe(
        third_party_python_package,
        name = "pypa_absl_py",
        target = "absl_py",
        requirement = "absl-py==2.0.0",
    )

def repo_pypa_alabaster():
    maybe(
        third_party_python_package,
        name = "pypa_alabaster",
        target = "alabaster",
        requirement = "alabaster==0.7.13",
    )

def repo_pypa_annotated_types():
    maybe(
        third_party_python_package,
        name = "pypa_annotated_types",
        target = "annotated_types",
        requirement = "annotated-types==0.6.0",
    )

def repo_pypa_appdirs():
    maybe(
        third_party_python_package,
        name = "pypa_appdirs",
        target = "appdirs",
        requirement = "appdirs==1.4.4",
    )

def repo_pypa_appnope():
    maybe(
        third_party_python_package,
        name = "pypa_appnope",
        target = "appnope",
        requirement = "appnope==0.1.3",
    )

def repo_pypa_asttokens():
    repo_pypa_six()
    maybe(
        third_party_python_package,
        name = "pypa_asttokens",
        target = "asttokens",
        requirement = "asttokens==2.4.1",
        deps = [
            "@pypa_six//:six",
        ],
    )

def repo_pypa_attrs():
    maybe(
        third_party_python_package,
        name = "pypa_attrs",
        target = "attrs",
        requirement = "attrs==23.1.0",
    )

def repo_pypa_babel():
    maybe(
        third_party_python_package,
        name = "pypa_babel",
        target = "babel",
        requirement = "babel==2.13.1",
    )

def repo_pypa_backcall():
    maybe(
        third_party_python_package,
        name = "pypa_backcall",
        target = "backcall",
        requirement = "backcall==0.2.0",
    )

def repo_pypa_blinker():
    maybe(
        third_party_python_package,
        name = "pypa_blinker",
        target = "blinker",
        requirement = "blinker==1.6.3",
    )

def repo_pypa_certifi():
    maybe(
        third_party_python_package,
        name = "pypa_certifi",
        target = "certifi",
        requirement = "certifi==2023.7.22",
    )

def repo_pypa_charset_normalizer():
    maybe(
        third_party_python_package,
        name = "pypa_charset_normalizer",
        target = "charset_normalizer",
        requirement = "charset-normalizer==3.3.1",
    )

def repo_pypa_click():
    maybe(
        third_party_python_package,
        name = "pypa_click",
        target = "click",
        requirement = "click==8.1.7",
    )

def repo_pypa_cloudpickle():
    maybe(
        third_party_python_package,
        name = "pypa_cloudpickle",
        target = "cloudpickle",
        requirement = "cloudpickle==3.0.0",
    )

def repo_pypa_colorama():
    maybe(
        third_party_python_package,
        name = "pypa_colorama",
        target = "colorama",
        requirement = "colorama==0.4.6",
    )

def repo_pypa_crc32c():
    maybe(
        third_party_python_package,
        name = "pypa_crc32c",
        target = "crc32c",
        requirement = "crc32c==2.3.post0",
    )

def repo_pypa_decorator():
    maybe(
        third_party_python_package,
        name = "pypa_decorator",
        target = "decorator",
        requirement = "decorator==5.1.1",
    )

def repo_pypa_docutils():
    maybe(
        third_party_python_package,
        name = "pypa_docutils",
        target = "docutils",
        requirement = "docutils==0.19",
    )

def repo_pypa_exceptiongroup():
    maybe(
        third_party_python_package,
        name = "pypa_exceptiongroup",
        target = "exceptiongroup",
        requirement = "exceptiongroup==1.1.3",
    )

def repo_pypa_executing():
    maybe(
        third_party_python_package,
        name = "pypa_executing",
        target = "executing",
        requirement = "executing==2.0.0",
    )

def repo_pypa_flask():
    repo_pypa_blinker()
    repo_pypa_click()
    repo_pypa_importlib_metadata()
    repo_pypa_itsdangerous()
    repo_pypa_jinja2()
    repo_pypa_werkzeug()
    maybe(
        third_party_python_package,
        name = "pypa_flask",
        target = "flask",
        requirement = "flask==3.0.0",
        deps = [
            "@pypa_blinker//:blinker",
            "@pypa_click//:click",
            "@pypa_importlib_metadata//:importlib_metadata",
            "@pypa_itsdangerous//:itsdangerous",
            "@pypa_jinja2//:jinja2",
            "@pypa_werkzeug//:werkzeug",
        ],
    )

def repo_pypa_googleapis_common_protos():
    repo_pypa_protobuf()
    maybe(
        third_party_python_package,
        name = "pypa_googleapis_common_protos",
        target = "googleapis_common_protos",
        requirement = "googleapis-common-protos==1.61.0",
        deps = [
            "@pypa_protobuf//:protobuf",
        ],
    )

def repo_pypa_grpcio():
    maybe(
        third_party_python_package,
        name = "pypa_grpcio",
        target = "grpcio",
        requirement = "grpcio==1.59.0",
    )

def repo_pypa_idna():
    maybe(
        third_party_python_package,
        name = "pypa_idna",
        target = "idna",
        requirement = "idna==3.4",
    )

def repo_pypa_imagesize():
    maybe(
        third_party_python_package,
        name = "pypa_imagesize",
        target = "imagesize",
        requirement = "imagesize==1.4.1",
    )

def repo_pypa_importlib_metadata():
    repo_pypa_zipp()
    maybe(
        third_party_python_package,
        name = "pypa_importlib_metadata",
        target = "importlib_metadata",
        requirement = "importlib-metadata==6.8.0",
        deps = [
            "@pypa_zipp//:zipp",
        ],
    )

def repo_pypa_iniconfig():
    maybe(
        third_party_python_package,
        name = "pypa_iniconfig",
        target = "iniconfig",
        requirement = "iniconfig==2.0.0",
    )

def repo_pypa_ipython():
    repo_pypa_appnope()
    repo_pypa_backcall()
    repo_pypa_colorama()
    repo_pypa_decorator()
    repo_pypa_exceptiongroup()
    repo_pypa_jedi()
    repo_pypa_matplotlib_inline()
    repo_pypa_pexpect()
    repo_pypa_pickleshare()
    repo_pypa_prompt_toolkit()
    repo_pypa_pygments()
    repo_pypa_stack_data()
    repo_pypa_traitlets()
    repo_pypa_typing_extensions()
    maybe(
        third_party_python_package,
        name = "pypa_ipython",
        target = "ipython",
        requirement = "ipython==8.16.1",
        deps = [
            "@pypa_appnope//:appnope",
            "@pypa_backcall//:backcall",
            "@pypa_colorama//:colorama",
            "@pypa_decorator//:decorator",
            "@pypa_exceptiongroup//:exceptiongroup",
            "@pypa_jedi//:jedi",
            "@pypa_matplotlib_inline//:matplotlib_inline",
            "@pypa_pexpect//:pexpect",
            "@pypa_pickleshare//:pickleshare",
            "@pypa_prompt_toolkit//:prompt_toolkit",
            "@pypa_pygments//:pygments",
            "@pypa_stack_data//:stack_data",
            "@pypa_traitlets//:traitlets",
            "@pypa_typing_extensions//:typing_extensions",
        ],
    )

def repo_pypa_itsdangerous():
    maybe(
        third_party_python_package,
        name = "pypa_itsdangerous",
        target = "itsdangerous",
        requirement = "itsdangerous==2.1.2",
    )

def repo_pypa_jedi():
    repo_pypa_parso()
    maybe(
        third_party_python_package,
        name = "pypa_jedi",
        target = "jedi",
        requirement = "jedi==0.19.1",
        deps = [
            "@pypa_parso//:parso",
        ],
    )

def repo_pypa_jinja2():
    repo_pypa_markupsafe()
    maybe(
        third_party_python_package,
        name = "pypa_jinja2",
        target = "jinja2",
        requirement = "jinja2==3.1.2",
        deps = [
            "@pypa_markupsafe//:markupsafe",
        ],
    )

def repo_pypa_jsonschema():
    repo_pypa_attrs()
    repo_pypa_jsonschema_specifications()
    repo_pypa_referencing()
    repo_pypa_rpds_py()
    maybe(
        third_party_python_package,
        name = "pypa_jsonschema",
        target = "jsonschema",
        requirement = "jsonschema==4.19.1",
        deps = [
            "@pypa_attrs//:attrs",
            "@pypa_jsonschema_specifications//:jsonschema_specifications",
            "@pypa_referencing//:referencing",
            "@pypa_rpds_py//:rpds_py",
        ],
    )

def repo_pypa_jsonschema_specifications():
    repo_pypa_referencing()
    maybe(
        third_party_python_package,
        name = "pypa_jsonschema_specifications",
        target = "jsonschema_specifications",
        requirement = "jsonschema-specifications==2023.7.1",
        deps = [
            "@pypa_referencing//:referencing",
        ],
    )

def repo_pypa_markupsafe():
    maybe(
        third_party_python_package,
        name = "pypa_markupsafe",
        target = "markupsafe",
        requirement = "markupsafe==2.1.3",
    )

def repo_pypa_matplotlib_inline():
    repo_pypa_traitlets()
    maybe(
        third_party_python_package,
        name = "pypa_matplotlib_inline",
        target = "matplotlib_inline",
        requirement = "matplotlib-inline==0.1.6",
        deps = [
            "@pypa_traitlets//:traitlets",
        ],
    )

def repo_pypa_ml_dtypes():
    repo_pypa_numpy()
    maybe(
        third_party_python_package,
        name = "pypa_ml_dtypes",
        target = "ml_dtypes",
        requirement = "ml-dtypes==0.3.1",
        deps = [
            "@pypa_numpy//:numpy",
        ],
    )

def repo_pypa_numpy():
    maybe(
        third_party_python_package,
        name = "pypa_numpy",
        target = "numpy",
        requirement = "numpy==1.26.1",
    )

def repo_pypa_packaging():
    maybe(
        third_party_python_package,
        name = "pypa_packaging",
        target = "packaging",
        requirement = "packaging==23.2",
    )

def repo_pypa_parso():
    maybe(
        third_party_python_package,
        name = "pypa_parso",
        target = "parso",
        requirement = "parso==0.8.3",
    )

def repo_pypa_pexpect():
    repo_pypa_ptyprocess()
    maybe(
        third_party_python_package,
        name = "pypa_pexpect",
        target = "pexpect",
        requirement = "pexpect==4.8.0",
        deps = [
            "@pypa_ptyprocess//:ptyprocess",
        ],
    )

def repo_pypa_pickleshare():
    maybe(
        third_party_python_package,
        name = "pypa_pickleshare",
        target = "pickleshare",
        requirement = "pickleshare==0.7.5",
    )

def repo_pypa_platformdirs():
    maybe(
        third_party_python_package,
        name = "pypa_platformdirs",
        target = "platformdirs",
        requirement = "platformdirs==3.11.0",
    )

def repo_pypa_pluggy():
    maybe(
        third_party_python_package,
        name = "pypa_pluggy",
        target = "pluggy",
        requirement = "pluggy==1.3.0",
    )

def repo_pypa_prompt_toolkit():
    repo_pypa_wcwidth()
    maybe(
        third_party_python_package,
        name = "pypa_prompt_toolkit",
        target = "prompt_toolkit",
        requirement = "prompt-toolkit==3.0.39",
        deps = [
            "@pypa_wcwidth//:wcwidth",
        ],
    )

def repo_pypa_protobuf():
    maybe(
        third_party_python_package,
        name = "pypa_protobuf",
        target = "protobuf",
        requirement = "protobuf==4.24.4",
    )

def repo_pypa_ptyprocess():
    maybe(
        third_party_python_package,
        name = "pypa_ptyprocess",
        target = "ptyprocess",
        requirement = "ptyprocess==0.7.0",
    )

def repo_pypa_pure_eval():
    maybe(
        third_party_python_package,
        name = "pypa_pure_eval",
        target = "pure_eval",
        requirement = "pure-eval==0.2.2",
    )

def repo_pypa_pydantic():
    repo_pypa_annotated_types()
    repo_pypa_pydantic_core()
    repo_pypa_typing_extensions()
    maybe(
        third_party_python_package,
        name = "pypa_pydantic",
        target = "pydantic",
        requirement = "pydantic==2.4.2",
        deps = [
            "@pypa_annotated_types//:annotated_types",
            "@pypa_pydantic_core//:pydantic_core",
            "@pypa_typing_extensions//:typing_extensions",
        ],
    )

def repo_pypa_pydantic_core():
    repo_pypa_typing_extensions()
    maybe(
        third_party_python_package,
        name = "pypa_pydantic_core",
        target = "pydantic_core",
        requirement = "pydantic-core==2.10.1",
        deps = [
            "@pypa_typing_extensions//:typing_extensions",
        ],
    )

def repo_pypa_pydantic_extra_types():
    repo_pypa_pydantic()
    maybe(
        third_party_python_package,
        name = "pypa_pydantic_extra_types",
        target = "pydantic_extra_types",
        requirement = "pydantic-extra-types==2.1.0",
        deps = [
            "@pypa_pydantic//:pydantic",
        ],
    )

def repo_pypa_pygments():
    maybe(
        third_party_python_package,
        name = "pypa_pygments",
        target = "pygments",
        requirement = "pygments==2.16.1",
    )

def repo_pypa_pytest():
    repo_pypa_colorama()
    repo_pypa_exceptiongroup()
    repo_pypa_iniconfig()
    repo_pypa_packaging()
    repo_pypa_pluggy()
    repo_pypa_tomli()
    maybe(
        third_party_python_package,
        name = "pypa_pytest",
        target = "pytest",
        requirement = "pytest==7.4.3",
        deps = [
            "@pypa_colorama//:colorama",
            "@pypa_exceptiongroup//:exceptiongroup",
            "@pypa_iniconfig//:iniconfig",
            "@pypa_packaging//:packaging",
            "@pypa_pluggy//:pluggy",
            "@pypa_tomli//:tomli",
        ],
    )

def repo_pypa_pytest_asyncio():
    repo_pypa_pytest()
    maybe(
        third_party_python_package,
        name = "pypa_pytest_asyncio",
        target = "pytest_asyncio",
        requirement = "pytest-asyncio==0.21.1",
        deps = [
            "@pypa_pytest//:pytest",
        ],
    )

def repo_pypa_pyyaml():
    maybe(
        third_party_python_package,
        name = "pypa_pyyaml",
        target = "pyyaml",
        requirement = "pyyaml==6.0.1",
    )

def repo_pypa_referencing():
    repo_pypa_attrs()
    repo_pypa_rpds_py()
    maybe(
        third_party_python_package,
        name = "pypa_referencing",
        target = "referencing",
        requirement = "referencing==0.30.2",
        deps = [
            "@pypa_attrs//:attrs",
            "@pypa_rpds_py//:rpds_py",
        ],
    )

def repo_pypa_requests():
    repo_pypa_certifi()
    repo_pypa_charset_normalizer()
    repo_pypa_idna()
    repo_pypa_urllib3()
    maybe(
        third_party_python_package,
        name = "pypa_requests",
        target = "requests",
        requirement = "requests==2.31.0",
        deps = [
            "@pypa_certifi//:certifi",
            "@pypa_charset_normalizer//:charset_normalizer",
            "@pypa_idna//:idna",
            "@pypa_urllib3//:urllib3",
        ],
    )

def repo_pypa_requests_toolbelt():
    repo_pypa_requests()
    maybe(
        third_party_python_package,
        name = "pypa_requests_toolbelt",
        target = "requests_toolbelt",
        requirement = "requests-toolbelt==1.0.0",
        deps = [
            "@pypa_requests//:requests",
        ],
    )

def repo_pypa_rpds_py():
    maybe(
        third_party_python_package,
        name = "pypa_rpds_py",
        target = "rpds_py",
        requirement = "rpds-py==0.10.6",
    )

def repo_pypa_scalpl():
    maybe(
        third_party_python_package,
        name = "pypa_scalpl",
        target = "scalpl",
        requirement = "scalpl==0.4.2",
    )

def repo_pypa_six():
    maybe(
        third_party_python_package,
        name = "pypa_six",
        target = "six",
        requirement = "six==1.16.0",
    )

def repo_pypa_snowballstemmer():
    maybe(
        third_party_python_package,
        name = "pypa_snowballstemmer",
        target = "snowballstemmer",
        requirement = "snowballstemmer==2.2.0",
    )

def repo_pypa_sphinx():
    repo_pypa_alabaster()
    repo_pypa_babel()
    repo_pypa_colorama()
    repo_pypa_docutils()
    repo_pypa_imagesize()
    repo_pypa_importlib_metadata()
    repo_pypa_jinja2()
    repo_pypa_packaging()
    repo_pypa_pygments()
    repo_pypa_requests()
    repo_pypa_snowballstemmer()
    repo_pypa_sphinxcontrib_applehelp()
    repo_pypa_sphinxcontrib_devhelp()
    repo_pypa_sphinxcontrib_htmlhelp()
    repo_pypa_sphinxcontrib_jsmath()
    repo_pypa_sphinxcontrib_qthelp()
    repo_pypa_sphinxcontrib_serializinghtml()
    maybe(
        third_party_python_package,
        name = "pypa_sphinx",
        target = "sphinx",
        requirement = "sphinx==6.0.1",
        deps = [
            "@pypa_alabaster//:alabaster",
            "@pypa_babel//:babel",
            "@pypa_colorama//:colorama",
            "@pypa_docutils//:docutils",
            "@pypa_imagesize//:imagesize",
            "@pypa_importlib_metadata//:importlib_metadata",
            "@pypa_jinja2//:jinja2",
            "@pypa_packaging//:packaging",
            "@pypa_pygments//:pygments",
            "@pypa_requests//:requests",
            "@pypa_snowballstemmer//:snowballstemmer",
            "@pypa_sphinxcontrib_applehelp//:sphinxcontrib_applehelp",
            "@pypa_sphinxcontrib_devhelp//:sphinxcontrib_devhelp",
            "@pypa_sphinxcontrib_htmlhelp//:sphinxcontrib_htmlhelp",
            "@pypa_sphinxcontrib_jsmath//:sphinxcontrib_jsmath",
            "@pypa_sphinxcontrib_qthelp//:sphinxcontrib_qthelp",
            "@pypa_sphinxcontrib_serializinghtml//:sphinxcontrib_serializinghtml",
        ],
    )

def repo_pypa_sphinx_immaterial():
    repo_pypa_appdirs()
    repo_pypa_markupsafe()
    repo_pypa_pydantic()
    repo_pypa_pydantic_extra_types()
    repo_pypa_requests()
    repo_pypa_sphinx()
    repo_pypa_typing_extensions()
    maybe(
        third_party_python_package,
        name = "pypa_sphinx_immaterial",
        target = "sphinx_immaterial",
        requirement = "sphinx-immaterial==0.11.7",
        deps = [
            "@pypa_appdirs//:appdirs",
            "@pypa_markupsafe//:markupsafe",
            "@pypa_pydantic//:pydantic",
            "@pypa_pydantic_extra_types//:pydantic_extra_types",
            "@pypa_requests//:requests",
            "@pypa_sphinx//:sphinx",
            "@pypa_typing_extensions//:typing_extensions",
        ],
    )

def repo_pypa_sphinxcontrib_applehelp():
    maybe(
        third_party_python_package,
        name = "pypa_sphinxcontrib_applehelp",
        target = "sphinxcontrib_applehelp",
        requirement = "sphinxcontrib-applehelp==1.0.7",
    )

def repo_pypa_sphinxcontrib_devhelp():
    maybe(
        third_party_python_package,
        name = "pypa_sphinxcontrib_devhelp",
        target = "sphinxcontrib_devhelp",
        requirement = "sphinxcontrib-devhelp==1.0.5",
    )

def repo_pypa_sphinxcontrib_htmlhelp():
    maybe(
        third_party_python_package,
        name = "pypa_sphinxcontrib_htmlhelp",
        target = "sphinxcontrib_htmlhelp",
        requirement = "sphinxcontrib-htmlhelp==2.0.4",
    )

def repo_pypa_sphinxcontrib_jsmath():
    maybe(
        third_party_python_package,
        name = "pypa_sphinxcontrib_jsmath",
        target = "sphinxcontrib_jsmath",
        requirement = "sphinxcontrib-jsmath==1.0.1",
    )

def repo_pypa_sphinxcontrib_qthelp():
    maybe(
        third_party_python_package,
        name = "pypa_sphinxcontrib_qthelp",
        target = "sphinxcontrib_qthelp",
        requirement = "sphinxcontrib-qthelp==1.0.6",
    )

def repo_pypa_sphinxcontrib_serializinghtml():
    maybe(
        third_party_python_package,
        name = "pypa_sphinxcontrib_serializinghtml",
        target = "sphinxcontrib_serializinghtml",
        requirement = "sphinxcontrib-serializinghtml==1.1.9",
    )

def repo_pypa_stack_data():
    repo_pypa_asttokens()
    repo_pypa_executing()
    repo_pypa_pure_eval()
    maybe(
        third_party_python_package,
        name = "pypa_stack_data",
        target = "stack_data",
        requirement = "stack-data==0.6.3",
        deps = [
            "@pypa_asttokens//:asttokens",
            "@pypa_executing//:executing",
            "@pypa_pure_eval//:pure_eval",
        ],
    )

def repo_pypa_tomli():
    maybe(
        third_party_python_package,
        name = "pypa_tomli",
        target = "tomli",
        requirement = "tomli==2.0.1",
    )

def repo_pypa_traitlets():
    maybe(
        third_party_python_package,
        name = "pypa_traitlets",
        target = "traitlets",
        requirement = "traitlets==5.12.0",
    )

def repo_pypa_typing_extensions():
    maybe(
        third_party_python_package,
        name = "pypa_typing_extensions",
        target = "typing_extensions",
        requirement = "typing-extensions==4.8.0",
    )

def repo_pypa_urllib3():
    maybe(
        third_party_python_package,
        name = "pypa_urllib3",
        target = "urllib3",
        requirement = "urllib3==2.0.7",
    )

def repo_pypa_wcwidth():
    maybe(
        third_party_python_package,
        name = "pypa_wcwidth",
        target = "wcwidth",
        requirement = "wcwidth==0.2.8",
    )

def repo_pypa_werkzeug():
    repo_pypa_markupsafe()
    maybe(
        third_party_python_package,
        name = "pypa_werkzeug",
        target = "werkzeug",
        requirement = "werkzeug==3.0.1",
        deps = [
            "@pypa_markupsafe//:markupsafe",
        ],
    )

def repo_pypa_yapf():
    repo_pypa_importlib_metadata()
    repo_pypa_platformdirs()
    repo_pypa_tomli()
    maybe(
        third_party_python_package,
        name = "pypa_yapf",
        target = "yapf",
        requirement = "yapf==0.40.2",
        deps = [
            "@pypa_importlib_metadata//:importlib_metadata",
            "@pypa_platformdirs//:platformdirs",
            "@pypa_tomli//:tomli",
        ],
    )

def repo_pypa_zipp():
    maybe(
        third_party_python_package,
        name = "pypa_zipp",
        target = "zipp",
        requirement = "zipp==3.17.0",
    )
