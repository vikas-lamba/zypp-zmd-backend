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
BuildRequires:  dejagnu gcc-c++ libzypp-devel sqlite-devel
License:        GPL
Group:          System/Management
BuildRoot:      %{_tmppath}/%{name}-%{version}-build
Autoreqprov:    on
Requires:       libzypp >= 1.3.1
Provides:       zmd-backend
Provides:       zmd-librc-backend
Obsoletes:      zmd-librc-backend
Summary:        ZMD backend for Package, Patch, Pattern, and Product Management
Version:        7.1.1.0
Release:        42.47
Source:         zmd-backend-%{version}.tar.bz2
Prefix:         /usr

%description
This package provides binaries which enable the ZENworks daemon (ZMD)
to perform its management tasks on the system.



Authors:
--------
    Klaus Kaempf <kkaempf@suse.de>

%prep
%setup -q -n zmd-backend-7.1.1.0

%build
mv configure.ac x
grep -v devel/ x > configure.ac
autoreconf --force --install --symlink --verbose
%{?suse_update_config:%{suse_update_config -f}}
./configure --prefix=%{prefix} --libdir=%{_libdir} --mandir=%{_mandir} --disable-static
make %{?jobs:-j %jobs}
#make check

%install
make install DESTDIR=$RPM_BUILD_ROOT
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