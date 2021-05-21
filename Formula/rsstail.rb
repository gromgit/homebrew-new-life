class Rsstail < Formula
  desc "Monitors an RSS feed and emits new entries when detected"
  homepage "https://web.archive.org/web/20200412143745/www.vanheusden.com/rsstail/"
  url "https://deb.debian.org/debian/pool/main/r/rsstail/rsstail_1.8.orig.tar.gz"
  sha256 "19284f3eca4bfa649f53848e19e6ee134bce17ccf2a22919cc8c600684877801"
  license "GPL-2.0-only"

  livecheck do
    url :homepage
    regex(/Latest release.*href=.*?rsstail[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-new-life/releases/download/rsstail-1.8"
    sha256 cellar: :any,                 big_sur:      "2170b49282c6c9ab5698705e6e67af8946922452d887718b7c188cd15d9532fc"
    sha256 cellar: :any,                 catalina:     "450e521bb6dd8e93fd4b6f69642ccccb37d8fbbaf7a1dfcae75edf0a92fc548f"
    sha256 cellar: :any,                 mojave:       "da50da0537b8dd5a3fe43c83e5cb044c5cb33b99a0d11ea908f0ab19cc882b1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "49dd12f6b38129acf4cc9c44fb619677b484992b176d85993835302009de71ce"
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
