export JAVA_HOME="/usr/lib/jvm/java-21-graalvm-ee"
export PATH="$JAVA_HOME/bin:$PATH"
export PATH="$PATH:$HOME/.local/share/coursier/bin"
export COURSIER_CACHE="$HOME/.cache/coursier"
export COURSIER_CONFIG_DIR="$HOME/.config/coursier"
export COURSIER_CREDENTIALS="$HOME/.config/coursier/credentials"
export COURSIER_REPOSITORIES="central|https://repo1.maven.org/maven2"
export COURSIER_EXPERIMENTAL=1
export COURSIER_NO_TERM=1
export COURSIER_MODE=offline
export COURSIER_PROGRESS=0
export COURSIER_BIN_DIR="$HOME/.local/share/coursier/bin"
# Remove or comment out the following if you want to always use GraalVM:
# eval "$(cs java --jvm 17 --env)"
export PATH="$PATH:$HOME/perl5/bin"
export PERL5LIB="$HOME/perl5/lib/perl5:$HOME/lib/perl5"
export PERL_LOCAL_LIB_ROOT="$HOME/perl5"
export PERL_MB_OPT="--install_base $HOME/perl5"
export PERL_MM_OPT="INSTALL_BASE=$HOME/perl5"
export PERL_CPANM_HOME="$HOME/.cpanm"
export PERL_CPANM_OPT="--local-lib=$HOME/perl5"
