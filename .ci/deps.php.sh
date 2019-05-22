# PHPMD installation
if [ ! -e ~/.local/bin/phpmd ]; then
  PHPMD='http://static.phpmd.org/php/latest/phpmd.phar'
  mkdir -p ~/.local/bin
  curl -fsSL -o  ~/.local/bin/phpmd "$PHPMD"
  chmod +x ~/.local/bin/phpmd
fi

pear install pear/PHP_CodeSniffer
phpenv rehash
