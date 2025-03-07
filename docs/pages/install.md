# Installation

## Production

<!-- tabs:start -->

### **rubygems.org (universal)**

```bash
gem install unisec
```

Gem: [unisec](https://rubygems.org/gems/unisec)

### **BlackArch**

From the repository:

```bash
pacman -S unisec
```

From git:

```bash
blackman -i unisec
```

PKGBUILD: [unisec](https://github.com/BlackArch/blackarch/blob/master/packages/unisec/PKGBUILD)

### **ArchLinux**

Manually:

```bash
git clone https://aur.archlinux.org/unisec.git
cd unisec
makepkg -sic
```

With an AUR helper ([Pacman wrappers](https://wiki.archlinux.org/index.php/AUR_helpers#Pacman_wrappers)), eg. pikaur:

```bash
pikaur -S unisec
```

AUR: [unisec](https://aur.archlinux.org/packages/unisec/)

<!-- tabs:end -->

## Development

It's better to use [ASDM-VM](https://asdf-vm.com/) to have latests version of ruby and to avoid trashing your system ruby.

<!-- tabs:start -->

### **rubygems.org**

```bash
gem install --development unisec
```

### **git**

Just replace `x.x.x` with the gem version you see after `gem build`.

```bash
git clone https://github.com//unisec.git unisec
cd unisec
gem install bundler
bundler install
gem build unisec.gemspec
gem install unisec-x.x.x.gem
```

Note: if an automatic install is needed you can get the version with `$ gem build unisec.gemspec | grep Version | cut -d' ' -f4`.

### **No install**

Run the library in irb without installing the gem.

From local file:

```bash
irb -Ilib -runisec
```

Same for the CLI tool:

```bash
ruby -Ilib -runisec bin/unisec
```

<!-- tabs:end -->
