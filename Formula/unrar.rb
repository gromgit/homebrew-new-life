class Unrar < Formula
  desc "Extract, view, and test RAR archives"
  homepage "https://www.rarlab.com/"
  url "https://www.rarlab.com/rar/unrarsrc-6.0.6.tar.gz"
  sha256 "011ef7290d3394a62bb5bfced914cd510a7eea7255cf69417f9c952bb6056588"

  livecheck do
    url "https://www.rarlab.com/rar_add.htm"
    regex(/href=.*?unrarsrc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-new-life/releases/download/unrar-6.0.6"
    sha256 cellar: :any, big_sur:  "53e69bc0b8b1173b1ab1dff9708534f90f753049a4cc88ec8f8857cd8b0dc789"
    sha256 cellar: :any, catalina: "c9ecafa14145d200872d09d67a378ff6f5289d69bcd82e2d487852a94d4a48fc"
    sha256 cellar: :any, mojave:   "b82b87158a5db800b935459464cbfd9ad4a4c79a36e3e9f69db8b34d05e568d5"
  end

  def install
    # upstream doesn't particularly care about their unix targets,
    # so we do the dirty work of renaming their shared objects to
    # dylibs for them.
    on_macos do
      inreplace "makefile", "libunrar.so", "libunrar.dylib"
    end

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
