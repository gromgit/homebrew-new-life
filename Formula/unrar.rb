class Unrar < Formula
  desc "Extract, view, and test RAR archives"
  homepage "https://www.rarlab.com/"
  url "https://www.rarlab.com/rar/unrarsrc-6.1.6.tar.gz"
  sha256 "67f4ab891c062218c2badfaac9c8cab5c8bfd5e96dabfca56c8faa3d209a801d"

  livecheck do
    url "https://www.rarlab.com/rar_add.htm"
    regex(/href=.*?unrarsrc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-new-life/releases/download/unrar-6.1.6"
    sha256 cellar: :any, arm64_monterey: "2f6254ec48487d1c93b3ef281f8640ad9c8cea7f2d0abca01a8fefdbb0cd19d1"
    sha256 cellar: :any, monterey:       "f1c9ddb6b88253da148920034b89878e5628df47ab7e5899c11a9a969605cd1f"
    sha256 cellar: :any, big_sur:        "ef51322b8c24a1ddadeb3a6650d28f21915e76dcd4e5cb44958c21d62b014b65"
    sha256 cellar: :any, catalina:       "286ca40bc896d8aa3318efbe6d8cf634f7c0c4e50a500b9f3d8c0567e7be47e5"
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

    system "#{bin}/unrar", "x", rarpath, testpath
    assert_equal "Homebrew\n", (testpath/contentpath).read
  end
end
