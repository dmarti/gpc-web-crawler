FROM jrei/systemd-debian
ENV TERM linux
ENV DEBIAN_FRONTEND=noninteractive

# Get repos and keys for Node and MySQL, then install needed packages
RUN apt update
RUN apt-get -y install apt-utils curl file gnupg lsb-release wget
RUN install -d -m 0755 /etc/apt/keyrings
RUN curl -fsSL https://deb.nodesource.com/setup_21.x | bash -
RUN curl -fsSL https://dev.mysql.com/get/mysql-apt-config_0.8.22-1_all.deb > /tmp/mysql.deb
RUN wget -q https://packages.mozilla.org/apt/repo-signing-key.gpg -O- | tee /etc/apt/keyrings/packages.mozilla.org.asc > /dev/null
RUN echo "deb [signed-by=/etc/apt/keyrings/packages.mozilla.org.asc] https://packages.mozilla.org/apt mozilla main" | tee -a /etc/apt/sources.list.d/mozilla.list > /dev/null
RUN echo "Package: *\nPin: origin packages.mozilla.org\nPin-Priority: 1000\n" | tee /etc/apt/preferences.d/mozilla 
RUN dpkg -i /tmp/mysql.deb
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv-keys B7B3B788A8D3785C
RUN apt update
RUN apt-get -y install apache2 firefox mysql-server nodejs
RUN apt-get clean && rm -rf /var/lib/apt/lists/*
