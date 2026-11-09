class Unrar < Formula
  desc "Extract, view, and test RAR archives"
  homepage "https://www.rarlab.com/"
  url "https://www.rarlab.com/rar/unrarsrc-7.3.2.tar.gz"
  sha256 "f61a1160d6e2ebbda2ad353c8e82f62ab4312f97fde23c6c2c982d25e0014f99"

  livecheck do
    url "https://www.rarlab.com/rar_add.htm"
    regex(/href=.*?unrarsrc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/gromgit/new-life"
    sha256 cellar: :any, arm64_golden_gate: "2a76b1e01800a1a46ec50799debfee054f7d061ff32c7aaf7b8d6c6aa9d3206d"
    sha256 cellar: :any, arm64_tahoe:       "1819d5f95e2a3f9bd2063617340f584cc73301b1cd6068498996f7efd56c6d36"
    sha256 cellar: :any, arm64_sequoia:     "4b4ee5a01aae47e9b2c3ed2b469580eae074fc926c1703238770a0d6535855bd"
    sha256 cellar: :any, arm64_linux:       "3661d387a62334fb369bf475bed1288a88be14640172eb73d90e040e392862e3"
    sha256 cellar: :any, x86_64_linux:      "5886d08457aa84b340a1e5067f1244071e7da8a9583bc52fd09b07a17b5c6e2a"
  end

  def install
    # upstream doesn't particularly care about their unix targets,
    # so we do the dirty work of renaming their shared objects to
    # dylibs for them.
    inreplace "makefile", "libunrar.so", "libunrar.dylib" if OS.mac?

    system "make"
    bin.install "unrar"

    # Explicitly clean up for the library build to avoid an issue with an
    # apparent implicit clean which confuses the dependencies.
    system "make", "clean"
    system "make", "lib"
    lib.install shared_library("libunrar")
  end

  test do
    contentpath = "directory/file.txt"
    rarpath = testpath/"archive.rar"
    data =  "UmFyIRoHAM+QcwAADQAAAAAAAACaCHQggDIACQAAAAkAAAADtPej1LZwZE" \
            "QUMBIApIEAAGRpcmVjdG9yeVxmaWxlLnR4dEhvbWVicmV3CsQ9ewBABwA="

    rarpath.write data.unpack1("m")
    assert_equal contentpath, `#{bin}/unrar lb #{rarpath}`.strip
    assert_equal 0, $CHILD_STATUS.exitstatus

    system bin/"unrar", "x", rarpath, testpath
    assert_equal "Homebrew\n", (testpath/contentpath).read
  end
end
