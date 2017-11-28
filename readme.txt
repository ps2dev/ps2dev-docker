 ====================
  What does this do?
 ====================

  This program will automatically build a docker image with the ps2dev
  toolchain ready to be used for homebrew development.

 ====================
  How do I build it?
 ====================

 Build the image:

   docker build -t ps2dev-docker .

 ==================
  How do I use it?
 ==================

 Run 'make' on the current directory:

   docker run -v `pwd`:/build ps2dev-docker /bin/bash -c "cd /build && make"

 ============================
  How do I save and load it?
 ============================

 Save the image:

   docker save ps2dev-docker | bzip2 > ps2dev-docker.tar.bz2

 Load the image:

   docker load < bzip2 -dc ps2dev-docker.tar.bz2
