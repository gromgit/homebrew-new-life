class Genstats < Formula
  desc "Generate statistics about stdin or textfiles"
  homepage "https://web.archive.org/web/20180831170016/www.vanheusden.com/genstats/"
  url "https://web.archive.org/web/20180831170016/www.vanheusden.com/genstats/genstats-1.2.tgz"
  sha256 "9988264357211a24f7024db05e24ed88db58227a626330114309147eb7078f6e"
  license "GPL-2.0-only"

  bottle do
    root_url "https://github.com/gromgit/homebrew-new-life/releases/download/genstats-1.2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6b72081733a7c87ac2c021814f6ca8a106cef851a481821214d4880a9441731a"
    sha256 cellar: :any_skip_relocation, monterey:       "fe6bc14e194ffd9e4b85f1393ba6adf8c33b27427932c884b0c60462b5ee740d"
    sha256 cellar: :any_skip_relocation, big_sur:        "e98102ff77ed777a5632fc7cc48a93b52c9b3098e9d11e389af97dd2b23ab0d7"
    sha256 cellar: :any_skip_relocation, catalina:       "231d0bf12f4136a79252269c26be58df088e747e7d687531907edb30e8a3866c"
    sha256 cellar: :any_skip_relocation, mojave:         "f5c2dc4eb62bc3668475fb762810221d0586a7e9cfd0c78a990788b1bb244b36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5ec270a8bd95b3def0808b6321031e85a0bd5aa9d005659b1557dbcb288efe91"
  end

  def install
    # Tried to make this a patch.  Applying the patch hunk would
    # fail, even though I used "git diff | pbcopy". Tried messing
    # with whitespace, # lines, etc.  Ugh.
    inreplace "br.cpp", /if \(_XOPEN_VERSION >= 600\)/,
                        "if (_XOPEN_VERSION >= 600) && !__APPLE__"

    system "make"
    bin.install "genstats"
    man1.install "genstats.1"
  end

  test do
    assert_match "    1     9      1.00% This is a test.", pipe_output("#{bin}/genstats", "This is a test.\n" * 9)
  end
end
