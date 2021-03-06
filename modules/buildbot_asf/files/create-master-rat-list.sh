#!/bin/sh

### WARNING THIS FILE IS IN PUPPET
### See buildbot_asf module ###

# Create a file containing all rat-report.xml files/paths
# for importing into a master rat report xsl.
cd /x1/buildmaster/master1

echo '<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [' > filelist.xml

ENTITIES=`find -L . -mindepth 2 -maxdepth 5 -name "rat-output.xml" -exec dirname {} \; | sort | perl -pe 's|./||'`
FULLNAME=`find -L . -mindepth 2 -maxdepth 5 -name "rat-output.xml" -exec dirname {} \; | sort | perl -pe 's|./public_html/projects/||' | perl -pe s'|/|-|g'`
for ENTITY in $ENTITIES ; do
echo "$ENTITY SYSTEM \"$ENTITY/rat-output.xml\">" | perl -pe s'|public_html/projects/|<!ENTITY |' >> filelist.xml
done
echo ']>
<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:template match="/">' >> filelist.xml

for NAME in $FULLNAME ; do
echo "<project name=\"$NAME\">" >> filelist.xml
echo "&$NAME;" >> filelist.xml
echo "</project>" >> filelist.xml
done
echo "</xsl:template>
</xsl:stylesheet>" >> filelist.xml

