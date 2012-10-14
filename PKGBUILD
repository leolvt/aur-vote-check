# Maintainer: Leonardo V. Teixeira <leolvt@gmail.com>
pkgname=aur-vote-check
pkgver=20121014
pkgrel=1
pkgdesc="Simple and interactive wrapper to the aurvote tool."
arch=('any')
url="https://github.com/leolvt/aur-vote-check"
license=('GPL')
depends=('aurvote')
makedepends=('git')

_gitroot=git://github.com/leolvt/$pkgname.git
_gitname=$pkgname

build() {
    cd "$srcdir"
    msg "Connecting to GIT server...."

    if [[ -d "$_gitname" ]]; then
        cd "$_gitname" && git pull origin
        msg "The local files are updated."
    else
        git clone "$_gitroot" "$_gitname" --depth=1 
    fi
    msg "GIT checkout done or server timeout"

}

package() {
    install -D -m 755 "$srcdir/$_gitname/$pkgname.pl" "$pkgdir/usr/bin/$pkgname"
}

# vim:set ts=4 sw=4 et:
