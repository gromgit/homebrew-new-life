class Unrar < Formula
  desc "Extract, view, and test RAR archives"
  homepage "https://www.rarlab.com/"
  url "https://www.rarlab.com/rar/unrarsrc-7.1.10.tar.gz"
  sha256 "72a9ccca146174f41876e8b21ab27e973f039c6d10b13aabcb320e7055b9bb98"

  livecheck do
    url "https://www.rarlab.com/rar_add.htm"
    regex(/href=.*?unrarsrc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/gromgit/new-life"
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "f16e6cf561b678a37df9d82d0c0813f395c3bbe549955cb7178ed0772cd3802c"
    sha256 cellar: :any,                 arm64_sonoma:  "fed380e8a79a6e395eee6fe4518d28a597ae65c8edbcf6aee1e9efaaf2137309"
    sha256 cellar: :any,                 ventura:       "67853dcdf35753ce3739cc798eb0f96d41be011cd85f27b9c1939e0d62012dd5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a68d0fb11faf3cc3974b1926fbbc7e87b552785a230e27e3c81714b5026fe9ad"
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
