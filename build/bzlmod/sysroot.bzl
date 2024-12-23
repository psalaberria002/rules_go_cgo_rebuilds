"""Sysroot bzlmod"""

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

# Look here for updated sysroots: https://chromium.googlesource.com/chromium/src/+/main/build/linux/sysroot_scripts/sysroots.json
SYSROOTS = {
    "bullseye_amd64": {
        "Sha256Sum": "dec7a3a0fc5b83b909cba1b6d119077e0429a138eadef6bf5a0f2e03b1904631",
        "SysrootDir": "debian_bullseye_amd64-sysroot",
        "Tarball": "debian_bullseye_amd64_sysroot.tar.xz",
        "URL": "https://commondatastorage.googleapis.com/chrome-linux-sysroot",
    },
    "bullseye_arm64": {
        "Sha256Sum": "308e23faba3174bd01accfe358467b8a40fad4db4c49ef629da30219f65a275f",
        "SysrootDir": "debian_bullseye_arm64-sysroot",
        "Tarball": "debian_bullseye_arm64_sysroot.tar.xz",
        "URL": "https://commondatastorage.googleapis.com/chrome-linux-sysroot",
    },
}

def _sysroot_impl(module_ctx):
    deps = []
    for (_, sysroot) in SYSROOTS.items():
        name = sysroot["Tarball"].split(".")[0]
        http_archive(
            name = name,
            build_file_content = """
filegroup(
    name = "sysroot",
    srcs = glob(["*/**"]),
    visibility = ["//visibility:public"],
)
            """,
            sha256 = sysroot["Sha256Sum"],
            type = "tar.xz",
            urls = ["%s/%s" % (sysroot["URL"], sysroot["Sha256Sum"])],
        )

        deps.append(name)

    return module_ctx.extension_metadata(
        root_module_direct_deps = deps,
        root_module_direct_dev_deps = [],
    )

sysroot = module_extension(
    _sysroot_impl,
)
