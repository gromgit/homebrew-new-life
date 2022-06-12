class Rsstail < Formula
  desc "Monitors an RSS feed and emits new entries when detected"
  homepage "https://web.archive.org/web/20200412143745/www.vanheusden.com/rsstail/"
  url "https://web.archive.org/web/20200412143745/www.vanheusden.com/rsstail/rsstail-2.1.tgz"
  sha256 "98df3e9dff48e1d177eb5188fe9341c3d93f6742cd3e4b225c202aa5c340e772"
  license "GPL-2.0-only"

  livecheck do
    url :homepage
    regex(/Latest release.*href=.*?rsstail[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-new-life/releases/download/rsstail-2.1"
    sha256 cellar: :any,                 arm64_monterey: "a3c32ec8504ca0b2e43756fdb0e46bc6a14e27e07de1d892cc59d2f12cadab04"
    sha256 cellar: :any,                 monterey:       "0796735eb0ce6436becb8a08352a1933efe09efffc42a52a84d0d3485aa04976"
    sha256 cellar: :any,                 big_sur:        "6338fffca791654e11d3c996a47ebe6527830957dbaa210f8fbcdb09904c19e9"
    sha256 cellar: :any,                 catalina:       "7299888957f771fd6835b7999b49135be7bd3ee584d1d8cb06363e2d0ffe3fe1"
    sha256 cellar: :any,                 mojave:         "ac2dce4d3128a835284f8a058d0c7a73385ba2a7a78c9798584ff2d0800dd354"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2cefb8c706b307204243611ea9822c9d860146318569b69fd1f51d1edcc2b993"
  end

  depends_on "libmrss"

  resource "libiconv_hook" do
    url "https://www.mirrorservice.org/sites/archive.ubuntu.com/ubuntu/pool/universe/liba/libapache-mod-encoding/libapache-mod-encoding_0.0.20021209.orig.tar.gz"
    sha256 "1319b3cffd60982f0c739be18f816be77e3af46cd9039ac54417c1219518cf89"
  end

  def install
    (buildpath/"libiconv_hook").install resource("libiconv_hook")
    cd "libiconv_hook/lib" do
      system "./configure", "--disable-shared"
      system "make"
    end

    libiconv = if OS.mac?
      "-liconv "
    else
      # libiconv is folded into libc in Linux
      ""
    end

    system "make", "LDFLAGS=#{libiconv}-liconv_hook -lmrss -L#{buildpath}/libiconv_hook/lib/.libs"
    man1.install "rsstail.1"
    bin.install "rsstail"
  end

  test do
    assert_match(/^Title: /,
                 shell_output("#{bin}/rsstail -1u https://developer.apple.com/news/rss/news.rss"))
  end
end
