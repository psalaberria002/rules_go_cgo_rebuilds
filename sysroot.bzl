"""Sysroot bzlmod"""

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

# Look here for updated sysroots: https://chromium.googlesource.com/chromium/src/+/main/build/linux/sysroot_scripts/sysroots.json
SYSROOT_BASE_URL = "https://commondatastorage.googleapis.com/chrome-linux-sysroot/toolchain"
SYSROOTS = {
    "org_chromium_sysroot_linux_amd64": {
        "sha1sum": "4c00ba2ad61ca7cc39392f192aa39420e086777c",
        "tarball": "debian_bullseye_amd64_sysroot.tar.xz",
        "integrity": "sha256-R8Au/ZIMf5xrmLFJhEMXCqYQJQfQZyr155QHCDPvdFQ=",
    },
    "org_chromium_sysroot_linux_arm64": {
        "sha1sum": "41a6c8dec4c4304d6509e30cbaf9218dffb4438e",
        "tarball": "debian_bullseye_arm64_sysroot.tar.xz",
        "integrity": "sha256-kC0aQKX9jDdko2yNN3r1lFqS49JkxiUoVb2k1++B098=",
    },
}

def _sysroot_impl(module_ctx):
    for (key, sysroot) in SYSROOTS.items():
        http_archive(
            name = key,
            build_file_content = """
filegroup(
    name = "sysroot",
    srcs = glob(["*/**"]),
    visibility = ["//visibility:public"],
)
            """,
            integrity = sysroot["integrity"],
            urls = ["%s/%s/%s" % (SYSROOT_BASE_URL, sysroot["sha1sum"], sysroot["tarball"])],
        )

    return module_ctx.extension_metadata(
        root_module_direct_deps = [s for s in SYSROOTS.keys()],
        root_module_direct_dev_deps = [],
    )

sysroot = module_extension(
    _sysroot_impl,
)
