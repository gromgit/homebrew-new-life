class Httping < Formula
  desc "Ping-like tool for HTTP requests"
  homepage "https://web.archive.org/web/20210212054801/www.vanheusden.com/httping/"
  url "https://deb.debian.org/debian/pool/main/h/httping/httping_2.5.orig.tar.gz"
  sha256 "be6bd3e5426f85545b6fa23f447dbb97fd7cc2704b8e2faf38b8690943211d9d"
  license "GPL-2.0-only"
  revision 2

  bottle do
    root_url "https://github.com/gromgit/homebrew-new-life/releases/download/httping-2.5"
    sha256 cellar: :any,                 big_sur:      "d6b14a4d2f6386a0812ee9d8e4fa36dde6c7df9aa96e278ac90668de5c857814"
    sha256 cellar: :any,                 catalina:     "ba381b9908696c1460e88b59e1b8b09a1cada2021fd2d12cc10a67d838375332"
    sha256 cellar: :any,                 mojave:       "9fc405def6d134a06bc3e949aad3a118247dd1c199c64c748d2ea68d3414573b"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "182067e30ef5120dfb6c92cb0d604d78eaafeb0f66a83dac930b43136c511df9"
  end

  depends_on "gettext"
  depends_on "openssl@1.1"

  def install
    # Reported upstream, see: https://github.com/Homebrew/homebrew/pull/28653
    inreplace %w[configure Makefile], "ncursesw", "ncurses"
    on_macos do
      ENV.append "LDFLAGS", "-lintl"
    end
    inreplace "Makefile", "cp nl.mo $(DESTDIR)/$(PREFIX)/share/locale/nl/LC_MESSAGES/httping.mo", ""
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"httping", "-c", "2", "-g", "https://brew.sh/"
  end
end
