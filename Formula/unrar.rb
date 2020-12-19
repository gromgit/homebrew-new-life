class Unrar < Formula
  desc "Extract, view, and test RAR archives"
  homepage "https://www.rarlab.com/"
  url "https://www.rarlab.com/rar/unrarsrc-6.0.3.tar.gz"
  sha256 "1def53392d879f9e304aa6eac1339cf41f9bce1111a2f5845071665738c4aca0"

  livecheck do
    url "https://www.rarlab.com/rar_add.htm"
    regex(/href=.*?unrarsrc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-new-life/releases/download/unrar-6.0.3"
    cellar :any
    sha256 "19d9fd2066fdc720bda1d6396b5b6fef613234cd3391f19d8455094bff7b6b74" => :big_sur
    sha256 "dd5734a40ad334e900f184b54adc0e074524b570b209e133359b608f379135aa" => :catalina
    sha256 "c1c434c6ead4d02ea7a970335c9e040c01088306e173399ca1b5b0a67766934b" => :mojave
    sha256 "031641d3f3363c1d6bccd30f248e3ebcbd5f1c22434089464708aae4d5462bf0" => :x86_64_linux
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
