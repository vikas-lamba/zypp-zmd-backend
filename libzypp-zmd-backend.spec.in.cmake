#
# spec file for package libzypp-zmd-backend (Version 7.1.1.0)
#
# Copyright (c) 2006 SUSE LINUX Products GmbH, Nuernberg, Germany.
# This file and all modifications and additions to the pristine
# package are under the same license as the package itself.
#
# Please submit bugfixes or comments via http://bugs.opensuse.org/
#

# norootforbuild

Name:           libzypp-zmd-backend
Version:        @VERSION@
Release:        0
License:        GPL
Group:          System/Management
Summary:        ZMD backend for Package, Patch, Pattern, and Product Management
Requires:       libzypp >= %( echo `rpm -q --queryformat '%{VERSION}-%{RELEASE}' libzypp`)
Provides:       zmd-backend
Provides:       zmd-librc-backend
Obsoletes:      zmd-librc-backend
Autoreqprov:    on
BuildRoot:      %{_tmppath}/%{name}-%{version}-build
BuildRequires:  cmake
BuildRequires:  dejagnu gcc-c++ 

%if %suse_version > 1010
BuildRequires:  sqlite-zmd sqlite-zmd-devel
%else
BuildRequires:  sqlite sqlite-devel
%endif

# API Changes in zypp 2.1
BuildRequires: libzypp-devel >= 2.8.7
BuildRequires: libzypp >= 2.8.7
Requires: libzypp >= 2.8.7

Source:         zmd-backend-%{version}.tar.bz2
Prefix:         /usr

%description
This package provides binaries which enable the ZENworks daemon (ZMD)
to perform its management tasks on the system.



Authors:
--------
    Klaus Kaempf <kkaempf@suse.de>

%prep
%setup -q -n zmd-backend-%{version}

%build
mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX=%{prefix} -DLIB=%{_lib} -DCMAKE_SKIP_RPATH=1  ..
CXXFLAGS="$RPM_OPT_FLAGS" \
make %{?jobs:-j %jobs}
#make check

%install
cd build
make install DESTDIR=$RPM_BUILD_ROOT
cd ..
mkdir -p $RPM_BUILD_ROOT/etc/logrotate.d
install -m 644 logrotate_zmd_backend  $RPM_BUILD_ROOT/etc/logrotate.d/zmd-backend
# Create filelist with translatins
#%{find_lang} zypp

%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr(-,root,root)
%{_libdir}/libzmd-backend.*
%dir %{_libdir}/zmd
%{_libdir}/zmd/*
%dir %{prefix}/include/zmd-backend
%{prefix}/include/zmd-backend/*
/etc/logrotate.d/zmd-backend
