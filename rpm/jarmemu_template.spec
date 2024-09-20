Name:           jarmemu
Version:        $VERSION
Release:        1
Summary:        JArmEmu Portable ARM Simulator
Group:          Development/Tools
License:        GPL-3.0
URL:            https://dwightstudio.fr/jarmemu
BuildArch:      noarch
ExclusiveArch:  %{java_arches} noarch

Source0:        https://github.com/Dwight-Studio/JArmEmu/archive/refs/tags/v%{version}.tar.gz

BuildRequires:  maven-local
BuildRequires:  maven-openjdk21
BuildRequires:  desktop-file-utils
BuildRequires:  xdg-utils

Requires:       bash
Requires:       jre >= 21
AutoReqProv:    no

%description
JArmEmu is a simple simulator with a graphical interface that offers basic control and information about a simulated ARMv7 architecture.

%prep
%setup -q -n JArmEmu-%{version}

%build
mvn clean package

%install
install -d %{buildroot}%{_javadir}/%{name}/
install -Dm 644 jarmemu-distribution/target/jarmemu/*.jar -t %{buildroot}%{_javadir}/%{name}/
install -Dm 644 jarmemu-distribution/target/jarmemu/lib/* -t %{buildroot}%{_javadir}/%{name}/lib/
install -Dm 755 resources/%{name} %{buildroot}%{_bindir}/%{name}

install -Dm 644 resources/icons/hicolor/scalable/apps/fr.dwightstudio.JArmEmu.svg %{buildroot}%{_datadir}/icons/hicolor/scalable/apps/fr.dwightstudio.JArmEmu.svg
install -Dm 644 resources/mime/packages/fr.dwightstudio.JArmEmu.xml %{buildroot}%{_datadir}/mime/packages/fr.dwightstudio.JArmEmu.xml
install -Dm 644 resources/metainfo/fr.dwightstudio.JArmEmu.metainfo.xml %{buildroot}%{_datadir}/metainfo/fr.dwightstudio.JArmEmu.metainfo.xml

desktop-file-install --dir=%{buildroot}%{_datadir}/applications resources/fr.dwightstudio.JArmEmu.desktop

%post
touch --no-create %{_datadir}/icons/hicolor
if [ -x %{_bindir}/gtk-update-icon-cache ]; then
    %{_bindir}/gtk-update-icon-cache -q %{_datadir}/icons/hicolor;
fi
update-mime-database %{_datadir}/mime &> /dev/null || :
update-desktop-database &> /dev/null || :

%postun
touch --no-create %{_datadir}/icons/hicolor
if [ -x %{_bindir}/gtk-update-icon-cache ]; then
    %{_bindir}/gtk-update-icon-cache -q %{_datadir}/icons/hicolor;
fi
update-mime-database %{_datadir}/mime &> /dev/null || :
update-desktop-database &> /dev/null || :

%files
%license LICENSE

%{_javadir}/%{name}
%{_datadir}/mime/packages/fr.dwightstudio.JArmEmu.xml
%{_datadir}/metainfo/fr.dwightstudio.JArmEmu.metainfo.xml
%{_datadir}/applications/fr.dwightstudio.JArmEmu.desktop
%{_datadir}/icons/hicolor/scalable/apps/fr.dwightstudio.JArmEmu.svg
%{_bindir}/%{name}

%changelog
* Thu Apr 25 2024 Alexandre Leconte <aleconte@dwightstudio.fr> - 0:0.2.0
- Building with maven instead of shipping pre-build binaries

* Wed Nov 8 2023 Alexandre Leconte <aleconte@dwightstudio.fr>
- Creating package
