%define debug_package %{nil}
%define mybuildnumber %{?build_number}%{?!build_number:1}

Summary:        Chunk Beancount input files into matching and non-matching output files.
Name:           bean-chunk
Version:        0.0.2
Release:        %{mybuildnumber}%{?dist}
License:        GPL
Group:          Financial/Accounting
Source:         %{name}-%{version}.tar.gz
URL:            https://github.com/Rudd-O/%{name}

BuildArch:      noarch

BuildRequires:  make sed

Requires:       /usr/bin/python3

%description
This program chunks Beancount files based on simple text matching.

%prep
%autosetup

%build
make DESTDIR=$RPM_BUILD_ROOT PREFIX=%{_prefix} BINDIR=%{_bindir}

%install
make install DESTDIR=$RPM_BUILD_ROOT PREFIX=%{_prefix} BINDIR=%{_bindir}

%files
%defattr(-,root,root)
%attr(0755, root, root) %{_bindir}/%{name}

%changelog
* Tue Nov 24 2020 Manuel Amador <rudd-o@rudd-o.com> 0.0.1-1
- First RPM packaging release
