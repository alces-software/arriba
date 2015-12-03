#==============================================================================
# Copyright (C) 2007-2015 Stephen F. Norledge and Alces Software Ltd.
#
# This file/package is part of Alces Arriba.
#
# Alces Arriba is free software: you can redistribute it and/or
# modify it under the terms of the GNU Affero General Public License
# as published by the Free Software Foundation, either version 3 of
# the License, or (at your option) any later version.
#
# Alces Arriba is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this package.  If not, see <http://www.gnu.org/licenses/>.
#
# For more information on Alces Arriba, please visit:
# https://github.com/alces-software/arriba
#==============================================================================
module Arriba
  module MimeType
    TYPES = {
      'ai'    => 'application/postscript',
      'eps'   => 'application/postscript',
      'exe'   => 'application/octet-stream',
      'pdf'   => 'application/pdf',
      'xml'   => 'application/xml',
      'odt'   => 'application/vnd.oasis.opendocument.text',
      'swf'   => 'application/x-shockwave-flash',
      # MS Office  - http://blogs.msdn.com/b/vsofficedeveloper/archive/2008/05/08/office-2007-open-xml-mime-types.aspx
      'doc'   => 'application/vnd.ms-word',
      'dot'   => 'application/vnd.ms-word',
      'docx'  => 'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
      '.docm' => 'application/vnd.ms-word.document.macroEnabled.12',
      '.dotm' => 'application/vnd.ms-word.template.macroEnabled.12',
      'xls'   => 'application/vnd.ms-excel',
      '.xlt'  => 'application/vnd.ms-excel',
      '.xla'  => 'application/vnd.ms-excel',
      'xlsx'  => 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
      'xltx'  => 'application/vnd.openxmlformats-officedocument.spreadsheetml.template',
      'xlsm'  => 'application/vnd.ms-excel.sheet.macroEnabled.12',
      'xltm'  => 'application/vnd.ms-excel.template.macroEnabled.12',
      'xlam'  => 'application/vnd.ms-excel.addin.macroEnabled.12',
      'xlsb'  => 'application/vnd.ms-excel.sheet.binary.macroEnabled.12',
      'ppt'   => 'application/vnd.ms-powerpoint',
      'pot'   => 'application/vnd.ms-powerpoint',
      'pps'   => 'application/vnd.ms-powerpoint',
      'ppa'   => 'application/vnd.ms-powerpoint',
      'pptx'  => 'application/vnd.openxmlformats-officedocument.presentationml.presentation',
      'potx'  => 'application/vnd.openxmlformats-officedocument.presentationml.template',
      'ppsx'  => 'application/vnd.openxmlformats-officedocument.presentationml.slideshow',
      'ppam'  => 'application/vnd.ms-powerpoint.addin.macroEnabled.12',
      'pptm'  => 'application/vnd.ms-powerpoint.presentation.macroEnabled.12',
      'potm'  => 'application/vnd.ms-powerpoint.template.macroEnabled.12',
      'ppsm'  => 'application/vnd.ms-powerpoint.slideshow.macroEnabled.12',
      # archives
      'gz'    => 'application/x-gzip',
      'tgz'   => 'application/x-gzip',
      'bz'    => 'application/x-bzip2',
      'bz2'   => 'application/x-bzip2',
      'tbz'   => 'application/x-bzip2',
      'zip'   => 'application/zip',
      'rar'   => 'application/x-rar',
      'tar'   => 'application/x-tar',
      '7z'    => 'application/x-7z-compressed',
      # texts
      'txt'   => 'text/plain',
      'php'   => 'text/x-php',
      'html'  => 'text/html',
      'htm'   => 'text/html',
      'js'    => 'text/javascript',
      'css'   => 'text/css',
      'rtf'   => 'text/rtf',
      'rtfd'  => 'text/rtfd',
      'py'    => 'text/x-python',
      'java'  => 'text/x-java-source',
      'rb'    => 'text/x-ruby',
      'sh'    => 'text/x-shellscript',
      'pl'    => 'text/x-perl',
      'sql'   => 'text/x-sql',
      # images
      'bmp'   => 'image/x-ms-bmp',
      'jpg'   => 'image/jpeg',
      'jpeg'  => 'image/jpeg',
      'gif'   => 'image/gif',
      'png'   => 'image/png',
      'tif'   => 'image/tiff',
      'tiff'  => 'image/tiff',
      'tga'   => 'image/x-targa',
      'psd'   => 'image/vnd.adobe.photoshop',
      # audio
      'mp3'   => 'audio/mpeg',
      'mid'   => 'audio/midi',
      'ogg'   => 'audio/ogg',
      'mp4a'  => 'audio/mp4',
      'wav'   => 'audio/wav',
      'wma'   => 'audio/x-ms-wma',
      # video
      'avi'   => 'video/x-msvideo',
      'dv'    => 'video/x-dv',
      'mp4'   => 'video/mp4',
      'mpeg'  => 'video/mpeg',
      'mpg'   => 'video/mpeg',
      'mov'   => 'video/quicktime',
      'wm'    => 'video/x-ms-wmv',
      'flv'   => 'video/x-flv',
      'mkv'   => 'video/x-matroska'
    }
		
    def self::for(ext)
      TYPES[ext]
    end
  end
end
