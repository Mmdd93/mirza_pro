#!/bin/bash


# Checking Root Access
if [[ $EUID -ne 0 ]]; then
    echo -e "\033[31m[ERROR]\033[0m Please run this script as \033[1mroot\033[0m."
    exit 1
fi


# ---------------------------------------
# Check SSL certificate expiry
# ---------------------------------------
check_ssl_expiry() {
    local domain=$1
    if [ -z "$domain" ] || [ "$domain" = "Not set" ]; then
        echo -e "\033[31mNo domain\033[0m"
        return
    fi

    echo -n "Checking SSL for $domain... " >&2
    
    # Get certificate expiry
    local expiry_info
    expiry_info=$(timeout 10 openssl s_client -connect "$domain:443" -servername "$domain" < /dev/null 2>/dev/null | openssl x509 -noout -dates 2>/dev/null)
    
    if [ $? -eq 0 ]; then
        local not_after
        not_after=$(echo "$expiry_info" | grep "notAfter" | cut -d= -f2)
        
        if [ -n "$not_after" ]; then
            local expiry_epoch
            expiry_epoch=$(date -d "$not_after" +%s 2>/dev/null)
            local current_epoch
            current_epoch=$(date +%s)
            local days_left
            days_left=$(( (expiry_epoch - current_epoch) / 86400 ))
            
            if [ $days_left -gt 30 ]; then
                echo -e "\033[32m${days_left}d\033[0m"
            elif [ $days_left -gt 7 ]; then
                echo -e "\033[33m${days_left}d\033[0m"
            else
                echo -e "\033[31m${days_left}d\033[0m"
            fi
        else
            echo -e "\033[31mNo cert\033[0m"
        fi
    else
        echo -e "\033[31mNo SSL\033[0m"
    fi
}

# ---------------------------------------
# Read and show all Mirza Bot configurations with SSL info
# ---------------------------------------
read_mirza_configs() {
    echo -e "\033[1;34m[INFO] Scanning Mirza Bot installations in /var/www/html...\033[0m"

    local configs
    configs=$(find /var/www/html -maxdepth 2 -mindepth 2 -type f -name "config.php" 2>/dev/null)

    if [ -z "$configs" ]; then
        echo -e "\033[31mNo Mirza Bot configurations found under /var/www/html.\033[0m"
        return 1
    fi

    for config_file in $configs; do
        bot_folder=$(basename "$(dirname "$config_file")")
        echo -e "\n\033[1;36m=================================================\033[0m"
        echo -e "\033[1;33m/var/www/html/\033[0m \033[1;32m$bot_folder\033[0m"
        echo -e "\033[1;36m=================================================\033[0m"

        # Simple and reliable extraction
        domain=$(grep "domainhosts" "$config_file" | head -1 | cut -d= -f2 | sed "s/[';]//g" | sed 's/\"//g' | xargs)
        dbname=$(grep "dbname" "$config_file" | head -1 | cut -d= -f2 | sed "s/[';]//g" | sed 's/\"//g' | xargs)
        usernamedb=$(grep "usernamedb" "$config_file" | head -1 | cut -d= -f2 | sed "s/[';]//g" | sed 's/\"//g' | xargs)
        usernamebot=$(grep "usernamebot" "$config_file" | head -1 | cut -d= -f2 | sed "s/[';]//g" | sed 's/\"//g' | xargs)
        apikey=$(grep "APIKEY" "$config_file" | head -1 | cut -d= -f2 | sed "s/[';]//g" | sed 's/\"//g' | xargs)
        adminnumber=$(grep "adminnumber" "$config_file" | head -1 | cut -d= -f2 | sed "s/[';]//g" | sed 's/\"//g' | xargs)

        # Get SSL expiry information
        ssl_info=$(check_ssl_expiry "$domain")

        # Display details
        echo -e "\033[36mDomain:\033[0m        ${domain:-\033[31mNot set\033[0m}"
        echo -e "\033[36mSSL Status:\033[0m    $ssl_info"
        echo -e "\033[36mDatabase:\033[0m      ${dbname:-\033[31mNot set\033[0m}"
        echo -e "\033[36mDB User:\033[0m       ${usernamedb:-\033[31mNot set\033[0m}"
        echo -e "\033[36mBot Username:\033[0m  ${usernamebot:-\033[31mNot set\033[0m}"
        echo -e "\033[36mAPI Key:\033[0m       ${apikey:-\033[31mNot set\033[0m}"
        echo -e "\033[36mAdmin Number:\033[0m  ${adminnumber:-\033[31mNot set\033[0m}"
    done

    echo -e "\n\033[1;32m[SUCCESS] Scan complete.\033[0m"
}

# ---------------------------------------
# Show detected bot folders
# ---------------------------------------
check_mirza_installation() {
    echo -e "\033[34mMirza bots:\033[0m"

    local configs
    configs=$(find /var/www/html -maxdepth 2 -mindepth 2 -type f -name "config.php" 2>/dev/null)

    if [ -z "$configs" ]; then
        echo -e "\033[31m[ERROR] No Mirza bot installations found.\033[0m"
        return 1
    fi

    for cfg in $configs; do
        bot_name=$(basename "$(dirname "$cfg")")
        echo -e "  /var/www/html/ \033[36m$bot_name\033[0m"
    done
}



# ---------------------------------------
# Show SSL status for all domains
# ---------------------------------------
show_ssl_status() {
    echo -e "\033[1;34m[INFO] Checking SSL status for all domains...\033[0m"
    
    local configs
    configs=$(find /var/www/html -maxdepth 2 -mindepth 2 -type f -name "config.php" 2>/dev/null)
    
    if [ -z "$configs" ]; then
        echo -e "\033[31mNo configurations found.\033[0m"
        return 1
    fi
    
    echo -e "\n\033[1;36m=================================================\033[0m"
    echo -e "\033[1;33mSSL Certificate Status\033[0m"
    echo -e "\033[1;36m=================================================\033[0m"
    
    for config_file in $configs; do
        domain=$(grep "domainhosts" "$config_file" | head -1 | cut -d= -f2 | sed "s/[';]//g" | sed 's/\"//g' | xargs)
        bot_folder=$(basename "$(dirname "$config_file")")
        
        if [ -n "$domain" ] && [ "$domain" != "Not set" ]; then
            echo -e "\n\033[1;35mBot: $bot_folder\033[0m"
            echo -e "\033[36mDomain: $domain\033[0m"
            echo -e "\033[36mSSL Status: $(check_ssl_expiry "$domain")\033[0m"
        fi
    done
    
    echo -e "\n\033[1;36m=================================================\033[0m"
    echo -e "\033[33mLegend: \033[32mGood (>30d) \033[33mWarning (7-30d) \033[31mCritical (<7d)\033[0m"
    echo -e "\033[1;36m=================================================\033[0m"
}

# ---------------------------------------
# Main Menu
# ---------------------------------------
show_menu() {
    while true; do
        clear
        check_mirza_installation
        echo ""
        echo -e "\033[1;36m=================================================\033[0m"
        echo -e "\033[1;36mMirza Bot Management Menu\033[0m"
        echo -e "\033[1;36m=================================================\033[0m"
        echo -e "\033[1;36m1.\033[0m Install Mirza (full setup)"
        echo -e "\033[1;36m2.\033[0m Install Additional Bot"
        echo -e "\033[1;36m3.\033[0m Update Bots"
        echo -e "\033[1;36m4.\033[0m Uninstall Mirza"
        echo -e "\033[1;36m5.\033[0m Remove Additional Bot"
        echo -e "\033[1;36m6.\033[0m Export Database"
        echo -e "\033[1;36m7.\033[0m Import Database"
        echo -e "\033[1;36m8.\033[0m Automated Backup"
        echo -e "\033[1;36m9.\033[0m Renew SSL Certificates"
        echo -e "\033[1;36m10.\033[0m Change Domain"
        echo -e "\033[1;36m11.\033[0m Show SSL Status"
        echo -e "\033[1;36m12.\033[0m Show Mirza bots details"
        echo -e "\033[1;36m0.\033[0m Exit"
        echo -e "\033[1;36m=================================================\033[0m"
        echo ""
        read -p "Select an option: " option

        case $option in
            1) 
                install_bot
                echo ""
                read -p "Press Enter to continue..."
                ;;
            2) 
                install_additional_bot
                echo ""
                read -p "Press Enter to continue..."
                ;;
            3) 
                update_bot
                echo ""
                read -p "Press Enter to continue..."
                ;;
            4) 
                remove_bot
                echo ""
                read -p "Press Enter to continue..."
                ;;
            5) 
                remove_additional_bot
                echo ""
                read -p "Press Enter to continue..."
                ;;
            6) 
                export_database
                echo ""
                read -p "Press Enter to continue..."
                ;;
            7) 
                import_database
                echo ""
                read -p "Press Enter to continue..."
                ;;
            8) 
                auto_backup
                echo ""
                read -p "Press Enter to continue..."
                ;;
            9) 
                renew_ssl
                echo ""
                read -p "Press Enter to continue..."
                ;;
            10) 
                change_domain
                echo ""
                read -p "Press Enter to continue..."
                ;;
            11) 
                show_ssl_status
                echo ""
                read -p "Press Enter to continue..."
                ;;
            12) 
                read_mirza_configs
                echo ""
                read -p "Press Enter to continue..."
                ;;
            0)
                echo -e "\033[32mExiting...\033[0m"
                exit 0 
                ;;
            *)
                echo -e "\033[31mInvalid option. Please try again.\033[0m"
                sleep 2
                ;;
        esac
    done
}

# Check if Marzban is installed
function check_marzban_installed() {
    if [ -f "/opt/marzban/docker-compose.yml" ]; then
        return 0  # Marzban installed
    else
        return 1  # Marzban not installed
    fi
}

# Detect database type for Marzban
function detect_database_type() {
    COMPOSE_FILE="/opt/marzban/docker-compose.yml"
    if [ ! -f "$COMPOSE_FILE" ]; then
        echo "unknown"  # File not found, cannot determine database type
        return 1
    fi
    if grep -q "^[[:space:]]*mysql:" "$COMPOSE_FILE"; then
        echo "mysql"
        return 0
    elif grep -q "^[[:space:]]*mariadb:" "$COMPOSE_FILE"; then
        echo "mariadb"
        return 1
    else
        echo "sqlite"  # Assume SQLite if neither MySQL nor MariaDB is found
        return 1
    fi
}

# Find a free port between 3300 and 3330
function find_free_port() {
    for port in {3300..3330}; do
        if ! ss -tuln | grep -q ":$port "; then
            echo "$port"
            return 0
        fi
    done
    echo -e "\033[31m[ERROR] No free port found between 3300 and 3330.\033[0m"
    exit 1
}
# Function to fix update issues by changing mirrors
function fix_update_issues() {
    echo -e "\e[33mTrying to fix update issues by changing mirrors...\033[0m"

    # Backup original sources.list
    cp /etc/apt/sources.list /etc/apt/sources.list.backup

    # Detect Ubuntu version
    if [ -f /etc/os-release ]; then
        . /etc/apt/sources.list
        VERSION_ID=$(cat /etc/os-release | grep VERSION_ID | cut -d '"' -f2)
        UBUNTU_CODENAME=$(cat /etc/os-release | grep UBUNTU_CODENAME | cut -d '=' -f2)
    else
        echo -e "\e[91mCould not detect Ubuntu version.\033[0m"
        return 1
    fi

    # Try different mirrors
    MIRRORS=(
        "archive.ubuntu.com"
        "us.archive.ubuntu.com"
        "fr.archive.ubuntu.com"
        "de.archive.ubuntu.com"
        "mirrors.digitalocean.com"
        "mirrors.linode.com"
    )

    for mirror in "${MIRRORS[@]}"; do
        echo -e "\e[33mTrying mirror: $mirror\033[0m"
        # Create new sources.list
        cat > /etc/apt/sources.list << EOF
deb http://$mirror/ubuntu/ $UBUNTU_CODENAME main restricted universe multiverse
deb http://$mirror/ubuntu/ $UBUNTU_CODENAME-updates main restricted universe multiverse
deb http://$mirror/ubuntu/ $UBUNTU_CODENAME-security main restricted universe multiverse
EOF

        # Try updating
        if apt-get update 2>/dev/null; then
            echo -e "\e[32mSuccessfully updated using mirror: $mirror\033[0m"
            return 0
        fi
    done

    # If all mirrors fail, restore original sources.list
    mv /etc/apt/sources.list.backup /etc/apt/sources.list
    echo -e "\e[91mAll mirrors failed. Restored original sources.list\033[0m"
    return 1
}

# Install Function
function install_bot() {
    echo -e "\e[32mInstalling mirza script ... \033[0m\n"

    # Prompt for bot folder name (default: mirzabotconfig)
    read -p "Enter bot folder name (default: mirzabotconfig): " bot_folder_name
    if [ -z "$bot_folder_name" ]; then
        bot_folder_name="mirzabotconfig"
    fi
    BOT_DIR="/var/www/html/$bot_folder_name"

    # Set database name based on folder name
    if [ "$bot_folder_name" = "mirzabotconfig" ]; then
        dbname="mirzabot"
    else
        dbname="mirzabot_${bot_folder_name}"
    fi

    # Check if Marzban is installed and redirect to appropriate function
    if check_marzban_installed; then
        echo -e "\033[41m[IMPORTANT WARNING]\033[0m \033[1;33mMarzban detected. Proceeding with Marzban-compatible installation.\033[0m"
        install_bot_with_marzban "$@"  # Pass any arguments (e.g., -v beta)
        return 0
    fi

    # Function to add the Ondrej Surý PPA for PHP
    add_php_ppa() {
        sudo add-apt-repository -y ppa:ondrej/php || {
            echo -e "\e[91mError: Failed to add PPA ondrej/php.\033[0m"
            return 1
        }
    }

    # Function to add the Ondrej Surý PPA for PHP with locale override
    add_php_ppa_with_locale() {
        sudo LC_ALL=C.UTF-8 add-apt-repository -y ppa:ondrej/php || {
            echo -e "\e[91mError: Failed to add PPA ondrej/php with locale override.\033[0m"
            return 1
        }
    }

    # Try adding the PPA with the system's default locale settings
if ! add_php_ppa; then
    echo "Failed to add PPA with default locale, retrying with locale override..."
    if ! add_php_ppa_with_locale; then
        echo "Failed to add PPA even with locale override. Exiting..."
        exit 1
    fi
fi


    # Try normal update/upgrade first
if ! (sudo apt update && sudo apt upgrade -y); then
    echo -e "\e[93mUpdate/upgrade failed. Attempting to fix using alternative mirrors...\033[0m"
    if fix_update_issues; then
        # Try update/upgrade again after fixing mirrors
        if sudo apt update && sudo apt upgrade -y; then
            echo -e "\e[92mThe server was successfully updated after fixing mirrors...\033[0m\n"
        else
            echo -e "\e[91mError: Failed to update even after trying alternative mirrors.\033[0m"
            exit 1
        fi
    else
        echo -e "\e[91mError: Failed to update/upgrade packages and mirror fix failed.\033[0m"
        exit 1
    fi
else
    echo -e "\e[92mThe server was successfully updated ...\033[0m\n"
fi


    sudo apt-get install software-properties-common || {
        echo -e "\e[91mError: Failed to install software-properties-common.\033[0m"
        exit 1
    }

    sudo apt install -y git unzip curl || {
        echo -e "\e[91mError: Failed to install required packages.\033[0m"
        exit 1
    }

    DEBIAN_FRONTEND=noninteractive sudo apt install -y php8.2 php8.2-fpm php8.2-mysql || {
        echo -e "\e[91mError: Failed to install PHP 8.2 and related packages.\033[0m"
        exit 1
    }

    # List of required packages
    PKG=(
        lamp-server^
        libapache2-mod-php
        mysql-server
        apache2
        php-mbstring
        php-zip
        php-gd
        php-json
        php-curl
    )

    # Installing required packages with error handling
    for i in "${PKG[@]}"; do
        dpkg -s $i &>/dev/null
        if [ $? -eq 0 ]; then
            echo "$i is already installed"
        else
            if ! DEBIAN_FRONTEND=noninteractive sudo apt install -y $i; then
                echo -e "\e[91mError installing $i. Exiting...\033[0m"
                exit 1
            fi
        fi
    done

    echo -e "\n\e[92mPackages Installed, Continuing ...\033[0m\n"

    # phpMyAdmin Configuration
    echo 'phpmyadmin phpmyadmin/dbconfig-install boolean true' | sudo debconf-set-selections
    echo 'phpmyadmin phpmyadmin/app-password-confirm password mirzahipass' | sudo debconf-set-selections
    echo 'phpmyadmin phpmyadmin/mysql/admin-pass password mirzahipass' | sudo debconf-set-selections
    echo 'phpmyadmin phpmyadmin/mysql/app-pass password mirzahipass' | sudo debconf-set-selections
    echo 'phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2' | sudo debconf-set-selections

    sudo apt-get install phpmyadmin -y || {
        echo -e "\e[91mError: Failed to install phpMyAdmin.\033[0m"
        exit 1
    }
    # Check and remove existing phpMyAdmin configuration
    if [ -f /etc/apache2/conf-available/phpmyadmin.conf ]; then
        sudo rm -f /etc/apache2/conf-available/phpmyadmin.conf && echo -e "\e[92mRemoved existing phpMyAdmin configuration.\033[0m"
    fi

    # Create symbolic link for phpMyAdmin configuration
    sudo ln -s /etc/phpmyadmin/apache.conf /etc/apache2/conf-available/phpmyadmin.conf || {
        echo -e "\e[91mError: Failed to create symbolic link for phpMyAdmin configuration.\033[0m"
        exit 1
    }

    sudo a2enconf phpmyadmin.conf || {
        echo -e "\e[91mError: Failed to enable phpMyAdmin configuration.\033[0m"
        exit 1
    }
    sudo systemctl restart apache2 || {
        echo -e "\e[91mError: Failed to restart Apache2 service.\033[0m"
        exit 1
    }

    # Additional package installations with error handling
    sudo apt-get install -y php-soap || {
        echo -e "\e[91mError: Failed to install php-soap.\033[0m"
        exit 1
    }

    sudo apt-get install libapache2-mod-php || {
        echo -e "\e[91mError: Failed to install libapache2-mod-php.\033[0m"
        exit 1
    }

    sudo systemctl enable mysql.service || {
        echo -e "\e[91mError: Failed to enable MySQL service.\033[0m"
        exit 1
    }
    sudo systemctl start mysql.service || {
        echo -e "\e[91mError: Failed to start MySQL service.\033[0m"
        exit 1
    }
    sudo systemctl enable apache2 || {
        echo -e "\e[91mError: Failed to enable Apache2 service.\033[0m"
        exit 1
    }
    sudo systemctl start apache2 || {
        echo -e "\e[91mError: Failed to start Apache2 service.\033[0m"
        exit 1
    }

    sudo apt-get install ufw -y || {
        echo -e "\e[91mError: Failed to install UFW.\033[0m"
        exit 1
    }
    ufw allow 'Apache' || {
        echo -e "\e[91mError: Failed to allow Apache in UFW.\033[0m"
        exit 1
    }
    sudo systemctl restart apache2 || {
        echo -e "\e[91mError: Failed to restart Apache2 service after UFW update.\033[0m"
        exit 1
    }

    sudo apt-get install -y git || {
        echo -e "\e[91mError: Failed to install Git.\033[0m"
        exit 1
    }
    sudo apt-get install -y wget || {
        echo -e "\e[91mError: Failed to install Wget.\033[0m"
        exit 1
    }
    sudo apt-get install -y unzip || {
        echo -e "\e[91mError: Failed to install Unzip.\033[0m"
        exit 1
    }
    sudo apt install curl -y || {
        echo -e "\e[91mError: Failed to install cURL.\033[0m"
        exit 1
    }
    sudo apt-get install -y php-ssh2 || {
        echo -e "\e[91mError: Failed to install php-ssh2.\033[0m"
        exit 1
    }
    sudo apt-get install -y libssh2-1-dev libssh2-1 || {
        echo -e "\e[91mError: Failed to install libssh2.\033[0m"
        exit 1
    }
    sudo apt install jq -y || {
        echo -e "\e[91mError: Failed to install jq.\033[0m"
        exit 1
    }

    sudo systemctl restart apache2.service || {
        echo -e "\e[91mError: Failed to restart Apache2 service.\033[0m"
        exit 1
    }

    # Check and remove existing directory before cloning Git repository
    if [ -d "$BOT_DIR" ]; then
        echo -e "\e[93mDirectory $BOT_DIR already exists. Removing...\033[0m"
        sudo rm -rf "$BOT_DIR" || {
            echo -e "\e[91mError: Failed to remove existing directory $BOT_DIR.\033[0m"
            exit 1
        }
    fi

    # Create bot directory
    sudo mkdir -p "$BOT_DIR"
    if [ ! -d "$BOT_DIR" ]; then
        echo -e "\e[91mError: Failed to create directory $BOT_DIR.\033[0m"
        exit 1
    fi

    # Check for version flag
    ZIP_URL="https://github.com/Mmdd93/mirza_pro/archive/refs/heads/main.zip"

    # Download and extract the repository
    TEMP_DIR="/tmp/mirzabot"
    mkdir -p "$TEMP_DIR"
    wget -O "$TEMP_DIR/bot.zip" "$ZIP_URL" || {
        echo -e "\e[91mError: Failed to download the specified version.\033[0m"
        exit 1
    }

    unzip "$TEMP_DIR/bot.zip" -d "$TEMP_DIR"
    EXTRACTED_DIR=$(find "$TEMP_DIR" -mindepth 1 -maxdepth 1 -type d)
    mv "$EXTRACTED_DIR"/* "$BOT_DIR" || {
        echo -e "\e[91mError: Failed to move extracted files.\033[0m"
        exit 1
    }
    rm -rf "$TEMP_DIR"

    sudo chown -R www-data:www-data "$BOT_DIR"
    sudo chmod -R 755 "$BOT_DIR"

    echo -e "\n\033[33mMirza config and script have been installed successfully.\033[0m"

    # Create configuration directory and credential file (safe & idempotent)
CONF_DIR="/root/confmirza"
DB_FILE="$CONF_DIR/dbrootmirza.txt"

# Ensure directory exists
if [ ! -d "$CONF_DIR" ]; then
    mkdir -p "$CONF_DIR" || {
        echo -e "\e[91mError: Failed to create $CONF_DIR.\033[0m"
        exit 1
    }
fi

# Generate random DB password (8 chars alnum)
randomdbpasstxt=$(openssl rand -base64 10 | tr -dc 'a-zA-Z0-9' | cut -c1-8)

# Ensure RANDOM_NUMBER is set (fallback if not)
: "${RANDOM_NUMBER:=0}"

# Write credentials atomically (overwrite if exists)
cat > "$DB_FILE" <<EOF
\$user = 'root';
\$pass = '${randomdbpasstxt}';
\$path = '${RANDOM_NUMBER}';
EOF

# Secure the file (only owner can read/write)
chmod 600 "$DB_FILE" || {
    echo -e "\e[91mError: Failed to set permissions for $DB_FILE.\033[0m"
    exit 1
}

sleep 1

# Verify contents
passs=$(grep '\$pass' "$DB_FILE" | cut -d"'" -f2)
userrr=$(grep '\$user' "$DB_FILE" | cut -d"'" -f2)

if [ -z "$userrr" ] || [ -z "$passs" ]; then
    echo -e "\e[91mError: credential file creation verification failed.\033[0m"
    exit 1
fi

echo -e "\e[32mFile $DB_FILE created successfully.\033[0m"
echo -e "User: $userrr"
echo -e "Password: $passs"


# Check if folder exists
if [ ! -d "/some/folder/path" ]; then
    # Try to alter MySQL user
    sudo mysql -u "$userrr" -p"$passs" -e "ALTER USER '$userrr'@'localhost' IDENTIFIED WITH mysql_native_password BY '$passs'; FLUSH PRIVILEGES;" 2>/dev/null
    if [ $? -ne 0 ]; then
        echo -e "\e[91mError: Failed to alter MySQL user. Attempting recovery...\033[0m"

        # Enable skip-grant-tables
        sudo sed -i '$ a skip-grant-tables' /etc/mysql/mysql.conf.d/mysqld.cnf
        sudo systemctl restart mysql

        # Reset root user
        sudo mysql <<EOF
DROP USER IF EXISTS 'root'@'localhost';
CREATE USER 'root'@'localhost' IDENTIFIED BY '${passs}';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' WITH GRANT OPTION;
FLUSH PRIVILEGES;
EOF

        # Disable skip-grant-tables
        sudo sed -i '/skip-grant-tables/d' /etc/mysql/mysql.conf.d/mysqld.cnf
        sudo systemctl restart mysql

        # Retry login
        echo "SELECT 1" | mysql -u"$userrr" -p"$passs" 2>/dev/null || {
            echo -e "\e[91mError: Recovery failed. MySQL login still not working.\033[0m"
            exit 1
        }
    fi

    echo "Folder created successfully!"
else
    echo "Folder already exists."
fi


    clear

    echo " "
    echo -e "\e[32m SSL \033[0m\n"

    read -p "Enter the domain: " domainname
    while [[ ! "$domainname" =~ ^[a-zA-Z0-9.-]+$ ]]; do
        echo -e "\e[91mInvalid domain format. Please try again.\033[0m"
        read -p "Enter the domain: " domainname
    done
    DOMAIN_NAME="$domainname"
    PATHS=$(cat /root/confmirza/dbrootmirza.txt | grep '$path' | cut -d"'" -f2)
    sudo ufw allow 80 || {
        echo -e "\e[91mError: Failed to allow port 80 in UFW.\033[0m"
        exit 1
    }
    sudo ufw allow 443 || {
        echo -e "\e[91mError: Failed to allow port 443 in UFW.\033[0m"
        exit 1
    }

    echo -e "\033[33mDisable apache2\033[0m"
    wait

    sudo systemctl stop apache2 || {
        echo -e "\e[91mError: Failed to stop Apache2.\033[0m"
        exit 1
    }
    sudo systemctl disable apache2 || {
        echo -e "\e[91mError: Failed to disable Apache2.\033[0m"
        exit 1
    }
    sudo apt install letsencrypt -y || {
        echo -e "\e[91mError: Failed to install letsencrypt.\033[0m"
        exit 1
    }
    sudo systemctl enable certbot.timer || {
        echo -e "\e[91mError: Failed to enable certbot timer.\033[0m"
        exit 1
    }
    sudo certbot certonly --standalone --agree-tos --preferred-challenges http -d $DOMAIN_NAME || {
        echo -e "\e[91mError: Failed to generate SSL certificate.\033[0m"
        exit 1
    }
    sudo apt install python3-certbot-apache -y || {
        echo -e "\e[91mError: Failed to install python3-certbot-apache.\033[0m"
        exit 1
    }
    sudo certbot --apache --agree-tos --preferred-challenges http -d $DOMAIN_NAME || {
        echo -e "\e[91mError: Failed to configure SSL with Certbot.\033[0m"
        exit 1
    }

    echo " "
    echo -e "\033[33mEnable apache2\033[0m"
    wait
    sudo systemctl enable apache2 || {
        echo -e "\e[91mError: Failed to enable Apache2.\033[0m"
        exit 1
    }
    sudo systemctl start apache2 || {
        echo -e "\e[91mError: Failed to start Apache2.\033[0m"
        exit 1
    }
    clear

    printf "\e[33m[+] \e[36mBot Token: \033[0m"
    read YOUR_BOT_TOKEN
    while [[ ! "$YOUR_BOT_TOKEN" =~ ^[0-9]{8,10}:[a-zA-Z0-9_-]{35}$ ]]; do
        echo -e "\e[91mInvalid bot token format. Please try again.\033[0m"
        printf "\e[33m[+] \e[36mBot Token: \033[0m"
        read YOUR_BOT_TOKEN
    done

    printf "\e[33m[+] \e[36mChat id: \033[0m"
    read YOUR_CHAT_ID
    while [[ ! "$YOUR_CHAT_ID" =~ ^-?[0-9]+$ ]]; do
        echo -e "\e[91mInvalid chat ID format. Please try again.\033[0m"
        printf "\e[33m[+] \e[36mChat id: \033[0m"
        read YOUR_CHAT_ID
    done

    YOUR_DOMAIN="$DOMAIN_NAME"

    while true; do
        printf "\e[33m[+] \e[36musernamebot: \033[0m"
        read YOUR_BOTNAME
        if [ "$YOUR_BOTNAME" != "" ]; then
            break
        else
            echo -e "\e[91mError: Bot username cannot be empty. Please enter a valid username.\033[0m"
        fi
    done

    ROOT_PASSWORD=$(cat /root/confmirza/dbrootmirza.txt | grep '$pass' | cut -d"'" -f2)
    ROOT_USER="root"
    echo "SELECT 1" | mysql -u$ROOT_USER -p$ROOT_PASSWORD 2>/dev/null || {
        echo -e "\e[91mError: MySQL connection failed.\033[0m"
        exit 1
    }

    if [ $? -eq 0 ]; then
        wait

        randomdbpass=$(openssl rand -base64 10 | tr -dc 'a-zA-Z0-9' | cut -c1-8)
        randomdbdb=$(openssl rand -base64 10 | tr -dc 'a-zA-Z' | cut -c1-8)

        if [[ $(mysql -u root -p$ROOT_PASSWORD -e "SHOW DATABASES LIKE '$dbname'") ]]; then
            clear
            echo -e "\n\e[91mYou have already created the database '$dbname'\033[0m\n"
        else
            clear
            echo -e "\n\e[32mPlease enter the database username!\033[0m"
            printf "[+] Default user name is \e[91m${randomdbdb}\e[0m ( let it blank to use this user name ): "
            read dbuser
            if [ "$dbuser" = "" ]; then
                dbuser=$randomdbdb
            fi

            echo -e "\n\e[32mPlease enter the database password!\033[0m"
            printf "[+] Default password is \e[91m${randomdbpass}\e[0m ( let it blank to use this password ): "
            read dbpass
            if [ "$dbpass" = "" ]; then
                dbpass=$randomdbpass
            fi

            mysql -u root -p$ROOT_PASSWORD -e "CREATE DATABASE $dbname;" -e "CREATE USER '$dbuser'@'%' IDENTIFIED WITH mysql_native_password BY '$dbpass';GRANT ALL PRIVILEGES ON * . * TO '$dbuser'@'%';FLUSH PRIVILEGES;" -e "CREATE USER '$dbuser'@'localhost' IDENTIFIED WITH mysql_native_password BY '$dbpass';GRANT ALL PRIVILEGES ON * . * TO '$dbuser'@'localhost';FLUSH PRIVILEGES;" || {
                echo -e "\e[91mError: Failed to create database or user.\033[0m"
                exit 1
            }

            echo -e "\n\e[95mDatabase '$dbname' Created.\033[0m"

            clear

            ASAS="$"

            wait

            sleep 1

            file_path="/var/www/html/$bot_folder_name/config.php"

            if [ -f "$file_path" ]; then
                rm "$file_path" || {
                    echo -e "\e[91mError: Failed to delete old config.php.\033[0m"
                    exit 1
                }
                echo -e "File deleted successfully."
            else
                echo -e "File not found."
            fi

            sleep 1

            secrettoken=$(openssl rand -base64 10 | tr -dc 'a-zA-Z0-9' | cut -c1-8)

            echo -e "<?php" >> /var/www/html/$bot_folder_name/config.php
            echo -e "${ASAS}APIKEY = '${YOUR_BOT_TOKEN}';" >> /var/www/html/$bot_folder_name/config.php
            echo -e "${ASAS}usernamedb = '${dbuser}';" >> /var/www/html/$bot_folder_name/config.php
            echo -e "${ASAS}passworddb = '${dbpass}';" >> /var/www/html/$bot_folder_name/config.php
            echo -e "${ASAS}dbname = '${dbname}';" >> /var/www/html/$bot_folder_name/config.php
            echo -e "${ASAS}domainhosts = '${YOUR_DOMAIN}';" >> /var/www/html/$bot_folder_name/config.php
            echo -e "${ASAS}adminnumber = '${YOUR_CHAT_ID}';" >> /var/www/html/$bot_folder_name/config.php
            echo -e "${ASAS}usernamebot = '${YOUR_BOTNAME}';" >> /var/www/html/$bot_folder_name/config.php
            echo -e "${ASAS}secrettoken = '${secrettoken}';" >> /var/www/html/$bot_folder_name/config.php
            echo -e "${ASAS}connect = mysqli_connect('localhost', \$usernamedb, \$passworddb, \$dbname);" >> /var/www/html/$bot_folder_name/config.php
            echo -e "if (${ASAS}connect->connect_error) {" >> /var/www/html/$bot_folder_name/config.php
            echo -e "die(' The connection to the database failed:' . ${ASAS}connect->connect_error);" >> /var/www/html/$bot_folder_name/config.php
            echo -e "}" >> /var/www/html/$bot_folder_name/config.php
            echo -e "mysqli_set_charset(${ASAS}connect, 'utf8mb4');" >> /var/www/html/$bot_folder_name/config.php
            text_to_save=$(cat <<EOF
\$options = [
    PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
    PDO::ATTR_EMULATE_PREPARES   => false,
];
\$dsn = "mysql:host=localhost;dbname=${ASAS}dbname;charset=utf8mb4";
try {
     \$pdo = new PDO(\$dsn, \$usernamedb, \$passworddb, \$options);
} catch (\PDOException \$e) {
     throw new \PDOException(\$e->getMessage(), (int)\$e->getCode());
}
EOF
)
            echo -e "$text_to_save" >> /var/www/html/$bot_folder_name/config.php
            echo -e "?>" >> /var/www/html/$bot_folder_name/config.php

            sleep 1

            curl -F "url=https://${YOUR_DOMAIN}/$bot_folder_name/index.php" \
                 -F "secret_token=${secrettoken}" \
                 "https://api.telegram.org/bot${YOUR_BOT_TOKEN}/setWebhook" || {
                echo -e "\e[91mError: Failed to set webhook for bot.\033[0m"
                exit 1
            }
            MESSAGE="? The bot is installed! for start the bot send /start command."
            curl -s -X POST "https://api.telegram.org/bot${YOUR_BOT_TOKEN}/sendMessage" -d chat_id="${YOUR_CHAT_ID}" -d text="$MESSAGE" || {
                echo -e "\e[91mError: Failed to send message to Telegram.\033[0m"
                exit 1
            }

            sleep 1
            sudo systemctl start apache2 || {
                echo -e "\e[91mError: Failed to start Apache2.\033[0m"
                exit 1
            }
            
            
   #################################         
            
   echo -e "\033[36mDatabase Import Tool\033[0m"

   

    # Set config path for selected bot
    BOT_DIR="/var/www/html/$bot_folder_name"
    CONFIG_FILE="$BOT_DIR/config.php"
    
    if [ ! -f "$CONFIG_FILE" ]; then
        echo -e "\033[31m[ERROR] config.php not found at $CONFIG_FILE\033[0m"
        return 1
    fi

    # Extract credentials from selected bot
    echo -e "\033[33mExtracting credentials from $SELECTED_BOT...\033[0m"
    DB_USER=$(grep '^\$usernamedb' "$CONFIG_FILE" | awk -F"'" '{print $2}')
    DB_PASS=$(grep '^\$passworddb' "$CONFIG_FILE" | awk -F"'" '{print $2}')
    DB_NAME=$(grep '^\$dbname' "$CONFIG_FILE" | awk -F"'" '{print $2}')
    TELEGRAM_TOKEN=$(grep '^\$APIKEY' "$CONFIG_FILE" | awk -F"'" '{print $2}')
    TELEGRAM_CHAT_ID=$(grep '^\$adminnumber' "$CONFIG_FILE" | awk -F"'" '{print $2}')

    if [ -z "$DB_USER" ] || [ -z "$DB_PASS" ] || [ -z "$DB_NAME" ]; then
        echo -e "\033[31m[ERROR] Failed to extract required database credentials from $CONFIG_FILE.\033[0m"
        return 1
    fi

    echo -e "\033[32mCredentials extracted successfully for $SELECTED_BOT\033[0m"
    echo -e "  Database: $DB_NAME"
    echo -e "  Username: $DB_USER"

    # Check if Marzban is installed
    if check_marzban_installed; then
        echo -e "\033[31m[ERROR]\033[0m Importing database is not supported when Marzban is installed due to database being managed by Docker."
        return 1
    fi

    echo -e "\033[33mVerifying database existence...\033[0m"

    if ! mysql -u "$DB_USER" -p"$DB_PASS" -e "USE $DB_NAME;" 2>/dev/null; then
        echo -e "\033[31m[ERROR]\033[0m Database $DB_NAME does not exist or credentials are incorrect."
        return 1
    fi

    # Automatically use mirzabot.sql in the bot directory
    BACKUP_FILE="$BOT_DIR/mirzabot.sql"
    
    if [ ! -f "$BACKUP_FILE" ]; then
        echo -e "\033[31m[ERROR] mirzabot.sql not found in $BOT_DIR\033[0m"
        echo -e "\033[33mAvailable files in $BOT_DIR:\033[0m"
        ls -la "$BOT_DIR" | head -10
        return 1
    fi

    echo -e "\033[33mUsing SQL file: $BACKUP_FILE\033[0m"
    echo -e "\033[33mFile size: $(du -h "$BACKUP_FILE" | cut -f1)\033[0m"

    # Simple approach: Drop all tables and import fresh
    echo -e "\033[33mDropping all existing tables...\033[0m"
    
    # Get list of tables and drop them
    TABLES=$(mysql -u "$DB_USER" -p"$DB_PASS" -D "$DB_NAME" -s -N -e "SHOW TABLES;")
    if [ -n "$TABLES" ]; then
        mysql -u "$DB_USER" -p"$DB_PASS" -D "$DB_NAME" -e "SET FOREIGN_KEY_CHECKS = 0;"
        for table in $TABLES; do
            mysql -u "$DB_USER" -p"$DB_PASS" -D "$DB_NAME" -e "DROP TABLE IF EXISTS \`$table\`;"
        done
        mysql -u "$DB_USER" -p"$DB_PASS" -D "$DB_NAME" -e "SET FOREIGN_KEY_CHECKS = 1;"
        echo -e "\033[32mAll tables dropped successfully.\033[0m"
    else
        echo -e "\033[32mDatabase was already empty.\033[0m"
    fi

    # Perform the import
    echo -e "\033[33mImporting database from $BACKUP_FILE...\033[0m"
    
    START_TIME=$(date +%s)
    
    if mysql -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" < "$BACKUP_FILE" 2>/tmp/import_error.log; then
        END_TIME=$(date +%s)
        DURATION=$((END_TIME - START_TIME))
        
        echo -e "\033[32mDatabase successfully imported from $BACKUP_FILE.\033[0m"
        echo -e "\033[33mImport completed in ${DURATION} seconds.\033[0m"
        
        # Verify import
        echo -e "\033[33mVerifying import...\033[0m"
        IMPORTED_TABLES=$(mysql -u "$DB_USER" -p"$DB_PASS" -D "$DB_NAME" -s -N -e "SHOW TABLES;" 2>/dev/null | wc -l)
        echo -e "\033[32mDatabase now contains $IMPORTED_TABLES tables.\033[0m"
        
        # Update admin ID if needed
        if [ -n "$TELEGRAM_CHAT_ID" ]; then
            echo -e "\033[33mUpdating admin ID to $TELEGRAM_CHAT_ID...\033[0m"
            mysql -u "$DB_USER" -p"$DB_PASS" -D "$DB_NAME" -e "UPDATE admin SET id_admin = '$TELEGRAM_CHAT_ID' WHERE id_admin != '$TELEGRAM_CHAT_ID';" 2>/dev/null
            echo -e "\033[32mAdmin ID updated.\033[0m"
        fi
        
    else
        echo -e "\033[31m[ERROR] Failed to import database from backup file.\033[0m"
        echo -e "\033[33mError details saved to /tmp/import_error.log\033[0m"
        return 1
    fi
    
##############################################  

echo -e "\033[36mApache Bot Configuration\033[0m"

    

   

    # Get domain from current config - more robust method
    CURRENT_DOMAIN=$(grep -E "^ServerName" /etc/apache2/sites-available/000-default-le-ssl.conf | awk '{print $2}' | head -1)
    
    # If domain is empty, try to get from SSL certificate files
    if [ -z "$CURRENT_DOMAIN" ]; then
        echo -e "\033[33mCould not detect domain from config. Checking SSL certificates...\033[0m"
        CURRENT_DOMAIN=$(ls /etc/letsencrypt/live/ | head -1)
    fi
    
    # If still empty, ask user
    if [ -z "$CURRENT_DOMAIN" ]; then
        echo -ne "\033[36mEnter your domain name: \033[0m"
        read CURRENT_DOMAIN
    fi

    # Verify SSL certificate exists
    if [ ! -f "/etc/letsencrypt/live/$CURRENT_DOMAIN/fullchain.pem" ]; then
        echo -e "\033[31m? SSL certificate not found for domain: $CURRENT_DOMAIN\033[0m"
        echo -e "\033[33mAvailable SSL certificates:\033[0m"
        ls /etc/letsencrypt/live/ 2>/dev/null || echo "No SSL certificates found"
        echo -ne "\033[36mEnter correct domain name: \033[0m"
        read CURRENT_DOMAIN
    fi

    echo -e "\033[32mUsing domain: $CURRENT_DOMAIN\033[0m"

    # Create new configuration
    CONFIG_FILE="/etc/apache2/sites-available/000-default-le-ssl.conf"
    
    cat <<EOF | sudo tee "$CONFIG_FILE" > /dev/null
<IfModule mod_ssl.c>
<VirtualHost *:443>

	ServerAdmin webmaster@localhost
	DocumentRoot /var/www/html/$bot_folder_name

	# Aliases for selected bot
	Alias /$bot_folder_name "/var/www/html/$bot_folder_name"
	Alias /$bot_folder_name/app "/var/www/html/$bot_folder_name/app"
	Alias /$bot_folder_name/panel "/var/www/html/$bot_folder_name/panel"

	# Directory permissions for main bot
	<Directory "/var/www/html/$bot_folder_name">
		Options Indexes FollowSymLinks
		AllowOverride All
		Require all granted
	</Directory>

	# Directory permissions for app
	<Directory "/var/www/html/$bot_folder_name/app">
		Options Indexes FollowSymLinks
		AllowOverride All
		Require all granted
	</Directory>

	# Directory permissions for panel
	<Directory "/var/www/html/$bot_folder_name/panel">
		Options Indexes FollowSymLinks
		AllowOverride All
		Require all granted
	</Directory>

	ErrorLog \${APACHE_LOG_DIR}/error.log
	CustomLog \${APACHE_LOG_DIR}/access.log combined

ServerName $CURRENT_DOMAIN
SSLCertificateFile /etc/letsencrypt/live/$CURRENT_DOMAIN/fullchain.pem
SSLCertificateKeyFile /etc/letsencrypt/live/$CURRENT_DOMAIN/privkey.pem
Include /etc/letsencrypt/options-ssl-apache.conf
</VirtualHost>
</IfModule>
EOF

    # Test and reload Apache
    echo -e "\033[33mTesting configuration...\033[0m"
    if sudo apache2ctl configtest; then
        echo -e "\033[33mReloading Apache...\033[0m"
        sudo systemctl reload apache2
        echo -e "\033[32m? Apache configured for $bot_folder_name\033[0m"
        echo -e "\033[36mMain URL: https://$CURRENT_DOMAIN/\033[0m"
        echo -e "\033[36mBot URL: https://$CURRENT_DOMAIN/$bot_folder_name/\033[0m"
        echo -e "\033[36mApp URL: https://$CURRENT_DOMAIN/$bot_folder_name/app/\033[0m"
        echo -e "\033[36mPanel URL: https://$CURRENT_DOMAIN/$bot_folder_name/panel/\033[0m"
    else
        echo -e "\033[31m? Configuration test failed\033[0m"
        echo -e "\033[33mTrying to fix configuration...\033[0m"
        
        # Try to get the correct domain from SSL directory
        CORRECT_DOMAIN=$(ls /etc/letsencrypt/live/ | head -1)
        if [ -n "$CORRECT_DOMAIN" ] && [ "$CORRECT_DOMAIN" != "$CURRENT_DOMAIN" ]; then
            echo -e "\033[33mUsing detected domain: $CORRECT_DOMAIN\033[0m"
            sudo sed -i "s|ServerName $CURRENT_DOMAIN|ServerName $CORRECT_DOMAIN|g" "$CONFIG_FILE"
            sudo sed -i "s|/etc/letsencrypt/live/$CURRENT_DOMAIN/|/etc/letsencrypt/live/$CORRECT_DOMAIN/|g" "$CONFIG_FILE"
            
            echo -e "\033[33mTesting configuration again...\033[0m"
            if sudo apache2ctl configtest; then
                echo -e "\033[33mReloading Apache...\033[0m"
                sudo systemctl reload apache2
                echo -e "\033[32m? Apache configured for $bot_folder_name\033[0m"
            else
                echo -e "\033[31m? Still failing. Please check Apache configuration manually.\033[0m"
            fi
        else
            echo -e "\033[31m? Please check your SSL certificate configuration.\033[0m"
        fi
        return 1
    fi
    
    ########################  

            clear

            echo " "
            echo -e "\e[102mDomain Bot: https://${YOUR_DOMAIN}/$bot_folder_name\033[0m"
            echo -e "\e[104mDatabase address: https://${YOUR_DOMAIN}/phpmyadmin\033[0m"
            echo -e "\e[33mDatabase name: \e[36m${dbname}\033[0m"
            echo -e "\e[33mDatabase username: \e[36m${dbuser}\033[0m"
            echo -e "\e[33mDatabase password: \e[36m${dbpass}\033[0m"
            echo -e "\e[33mBot folder: \e[36m${bot_folder_name}\033[0m"
            echo " "
            echo -e "Mirza Bot"
        fi

    elif [ "$ROOT_PASSWORD" = "" ] || [ "$ROOT_USER" = "" ]; then
        echo -e "\n\e[36mThe password is empty.\033[0m\n"
    else
        echo -e "\n\e[36mThe password is not correct.\033[0m\n"
    fi
    
    # Function to configure Apache for bot directories
    

    # Add executable permission and link
    chmod +x /root/install.sh
    ln -vs /root/install.sh /usr/local/bin/mirza
}


# Function to configure Apache for bot directories
# Function to configure Apache for bot directories

# Install Function with Marzban
function install_bot_with_marzban() {
    # Display warning and confirmation
    echo -e "\033[41m[IMPORTANT WARNING]\033[0m \033[1;33mMarzban panel is detected on your server. Please make sure to backup the Marzban database before installing Mirza Bot.\033[0m"
    read -p "Are you sure you want to install Mirza Bot alongside Marzban? (y/n): " confirm
    if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
        echo -e "\e[91mInstallation aborted by user.\033[0m"
        exit 0
    fi

    # Prompt for bot folder name (default: mirzabotconfig)
    read -p "Enter bot folder name (default: mirzabotconfig): " bot_folder_name
    if [ -z "$bot_folder_name" ]; then
        bot_folder_name="mirzabotconfig"
    fi
    BOT_DIR="/var/www/html/$bot_folder_name"

    # Set database name based on folder name
    if [ "$bot_folder_name" = "mirzabotconfig" ]; then
        dbname="mirzabot"
    else
        dbname="mirzabot_${bot_folder_name}"
    fi

    # Check database type
    echo -e "\e[32mChecking Marzban database type...\033[0m"
    DB_TYPE=$(detect_database_type)
    if [ "$DB_TYPE" != "mysql" ]; then
        echo -e "\e[91mError: Your database is $DB_TYPE. To install Mirza Bot, you must use MySQL.\033[0m"
        echo -e "\e[93mPlease configure Marzban to use MySQL and try again.\033[0m"
        exit 1
    fi
    echo -e "\e[92mMySQL detected. Proceeding with installation...\033[0m"

    # Check if port 80 and 88 are free before proceeding
    echo -e "\e[32mChecking port availability...\033[0m"
    if sudo ss -tuln | grep -q ":80 "; then
        echo -e "\e[91mError: Port 80 is already in use. Please free port 80 and run the script again.\033[0m"
        exit 1
    fi
    if sudo ss -tuln | grep -q ":88 "; then
        echo -e "\e[91mError: Port 88 is already in use. Please free port 88 and run the script again.\033[0m"
        exit 1
    fi
    echo -e "\e[92mPorts 80 and 88 are free. Proceeding with installation...\033[0m"

    # Try normal update/upgrade first
    if ! (sudo apt update && sudo apt upgrade -y); then
        echo -e "\e[93mUpdate/upgrade failed. Attempting to fix using alternative mirrors...\033[0m"
        if fix_update_issues; then
            # Try update/upgrade again after fixing mirrors
            if sudo apt update && sudo apt upgrade -y; then
                echo -e "\e[92mSystem updated successfully after fixing mirrors...\033[0m\n"
            else
                echo -e "\e[91mError: Failed to update even after trying alternative mirrors.\033[0m"
                exit 1
            fi
        else
            echo -e "\e[91mError: Failed to update/upgrade system and mirror fix failed.\033[0m"
            exit 1
        fi
    else
        echo -e "\e[92mSystem updated successfully...\033[0m\n"
    fi

    # Install required packages
    sudo apt-get install -y software-properties-common || {
        echo -e "\e[91mError: Failed to install software-properties-common.\033[0m"
        exit 1
    }

    # Install MySQL client if not already installed
    echo -e "\e[32mChecking and installing MySQL client...\033[0m"
    if ! command -v mysql &>/dev/null; then
        sudo apt install -y mysql-client || {
            echo -e "\e[91mError: Failed to install MySQL client. Please install it manually and try again.\033[0m"
            exit 1
        }
        echo -e "\e[92mMySQL client installed successfully.\033[0m"
    else
        echo -e "\e[92mMySQL client is already installed.\033[0m"
    fi

    # Add Ondrej Surý PPA for PHP 8.2
    sudo add-apt-repository -y ppa:ondrej/php || {
        echo -e "\e[91mError: Failed to add PPA ondrej/php. Trying with locale override...\033[0m"
        sudo LC_ALL=C.UTF-8 add-apt-repository -y ppa:ondrej/php || {
            echo -e "\e[91mError: Failed to add PPA even with locale override.\033[0m"
            exit 1
        }
    }
    sudo apt update || {
        echo -e "\e[91mError: Failed to update package list after adding PPA.\033[0m"
        exit 1
    }

    # Install all required packages
    sudo apt install -y git unzip curl wget jq || {
        echo -e "\e[91mError: Failed to install basic tools.\033[0m"
        exit 1
    }

    # Install Apache if not installed
    if ! dpkg -s apache2 &>/dev/null; then
        sudo apt install -y apache2 || {
            echo -e "\e[91mError: Failed to install Apache2.\033[0m"
            exit 1
        }
    fi

    # Install PHP 8.2 and all necessary modules (including PDO)
    DEBIAN_FRONTEND=noninteractive sudo apt install -y php8.2 php8.2-fpm php8.2-mysql php8.2-mbstring php8.2-zip php8.2-gd php8.2-curchmod +x /root/install.sh
    ln -vs /root/install.sh /usr/local/bin/mirza
l php8.2-soap php8.2-ssh2 libssh2-1-dev libssh2-1 php8.2-pdo || {
        echo -e "\e[91mError: Failed to install PHP 8.2 and modules.\033[0m"
        exit 1
    }

    # Install additional Apache module
    sudo apt install -y libapache2-mod-php8.2 || {
        echo -e "\e[91mError: Failed to install libapache2-mod-php8.2.\033[0m"
        exit 1
    }

    sudo apt install -y python3-certbot-apache || {
        echo -e "\e[91mError: Failed to install Certbot for Apache.\033[0m"
        exit 1
    }
    sudo systemctl enable certbot.timer || {
        echo -e "\e[91mError: Failed to enable certbot timer.\033[0m"
        exit 1
    }

    # Install UFW if not present
    if ! dpkg -s ufw &>/dev/null; then
        sudo apt install -y ufw || {
            echo -e "\e[91mError: Failed to install UFW.\033[0m"
            exit 1
        }
    fi

    # Check Marzban and use its MySQL (Docker-based)
    ENV_FILE="/opt/marzban/.env"
    if [ ! -f "$ENV_FILE" ]; then
        echo -e "\e[91mError: Marzban .env file not found. Cannot proceed without Marzban configuration.\033[0m"
        exit 1
    fi

    # Get MySQL root password from .env
    MYSQL_ROOT_PASSWORD=$(grep "MYSQL_ROOT_PASSWORD=" "$ENV_FILE" | cut -d'=' -f2 | tr -d '[:space:]' | sed 's/"//g')
    ROOT_USER="root"

    # Check if MYSQL_ROOT_PASSWORD is empty or invalid
    if [ -z "$MYSQL_ROOT_PASSWORD" ]; then
        echo -e "\e[93mWarning: Could not retrieve MySQL root password from Marzban .env file.\033[0m"
        read -s -p "Please enter the MySQL root password manually: " MYSQL_ROOT_PASSWORD
        echo
    fi

    # Dynamically find the MySQL container
    MYSQL_CONTAINER=$(docker ps -q --filter "name=mysql" --no-trunc)
    if [ -z "$MYSQL_CONTAINER" ]; then
        echo -e "\e[91mError: Could not find a running MySQL container. Ensure Marzban is running with Docker.\033[0m"
        echo -e "\e[93mRunning containers:\033[0m"
        docker ps
        exit 1
    fi

    echo "Testing MySQL connection..."

    # Try connecting directly to host first (for mysql:latest with network_mode: host)
    mysql -u "$ROOT_USER" -p"$MYSQL_ROOT_PASSWORD" -h 127.0.0.1 -P 3306 -e "SELECT 1;" 2>/tmp/mysql_error.log
    if [ $? -eq 0 ]; then
        echo -e "\e[92mMySQL connection successful (direct host method).\033[0m"
    else
        # If direct connection fails, try inside container (for mysql:lts)
        if [ -n "$MYSQL_CONTAINER" ]; then
            echo -e "\e[93mDirect connection failed, trying inside container...\033[0m"
            docker exec "$MYSQL_CONTAINER" bash -c "echo 'SELECT 1;' | mysql -u '$ROOT_USER' -p'$MYSQL_ROOT_PASSWORD'" 2>/tmp/mysql_error.log
            if [ $? -eq 0 ]; then
                echo -e "\e[92mMySQL connection successful (container method).\033[0m"
            else
                echo -e "\e[91mError: Failed to connect to MySQL using both methods.\033[0m"
                echo -e "\e[93mPassword used: '$MYSQL_ROOT_PASSWORD'\033[0m"
                echo -e "\e[93mError details:\033[0m"
                cat /tmp/mysql_error.log
                echo -e "\e[93mPlease ensure MySQL is running and the root password is correct.\033[0m"
                read -s -p "Enter the correct MySQL root password: " NEW_PASSWORD
                echo
                MYSQL_ROOT_PASSWORD="$NEW_PASSWORD"
                # Retry with new password (direct method first)
                mysql -u "$ROOT_USER" -p"$MYSQL_ROOT_PASSWORD" -h 127.0.0.1 -P 3306 -e "SELECT 1;" 2>/tmp/mysql_error.log || {
                    docker exec "$MYSQL_CONTAINER" bash -c "echo 'SELECT 1;' | mysql -u '$ROOT_USER' -p'$MYSQL_ROOT_PASSWORD'" 2>/tmp/mysql_error.log || {
                        echo -e "\e[91mError: Still can't connect with new password.\033[0m"
                        echo -e "\e[93mError details:\033[0m"
                        cat /tmp/mysql_error.log
                        exit 1
                    }
                }
                echo -e "\e[92mMySQL connection successful with new password.\033[0m"
            fi
        else
            echo -e "\e[91mError: No MySQL container found and direct connection failed.\033[0m"
            echo -e "\e[93mPassword used: '$MYSQL_ROOT_PASSWORD'\033[0m"
            echo -e "\e[93mError details:\033[0m"
            cat /tmp/mysql_error.log
            exit 1
        fi
    fi

    # Ask for database username and password
    clear
    echo -e "\e[33mConfiguring Mirza Bot database credentials...\033[0m"
    default_dbuser=$(openssl rand -base64 12 | tr -dc 'a-zA-Z' | head -c8)
    printf "\e[33m[+] \e[36mDatabase username (default: $default_dbuser): \033[0m"
    read dbuser
    if [ -z "$dbuser" ]; then
        dbuser="$default_dbuser"
    fi

    default_dbpass=$(openssl rand -base64 12 | tr -dc 'a-zA-Z0-9' | head -c12)
    printf "\e[33m[+] \e[36mDatabase password (default: $default_dbpass): \033[0m"
    read -s dbpass
    echo
    if [ -z "$dbpass" ]; then
        dbpass="$default_dbpass"
    fi

    # Create database and user inside Docker container
    docker exec "$MYSQL_CONTAINER" bash -c "mysql -u '$ROOT_USER' -p'$MYSQL_ROOT_PASSWORD' -e \"CREATE DATABASE IF NOT EXISTS $dbname; CREATE USER IF NOT EXISTS '$dbuser'@'%' IDENTIFIED BY '$dbpass'; GRANT ALL PRIVILEGES ON $dbname.* TO '$dbuser'@'%'; FLUSH PRIVILEGES;\"" || {
        echo -e "\e[91mError: Failed to create database or user in Marzban MySQL container.\033[0m"
        exit 1
    }
    echo -e "\e[92mDatabase '$dbname' created successfully.\033[0m"

    # Bot directory setup
    if [ -d "$BOT_DIR" ]; then
        echo -e "\e[93mDirectory $BOT_DIR already exists. Removing...\033[0m"
        sudo rm -rf "$BOT_DIR" || {
            echo -e "\e[91mError: Failed to remove existing directory $BOT_DIR.\033[0m"
            exit 1
        }
    fi
    sudo mkdir -p "$BOT_DIR" || {
        echo -e "\e[91mError: Failed to create directory $BOT_DIR.\033[0m"
        exit 1
    }

    # Download bot files
    ZIP_URL="https://github.com/Mmdd93/mirza_pro/archive/refs/heads/main.zip"
    TEMP_DIR="/tmp/mirzabot"
    mkdir -p "$TEMP_DIR"
    wget -O "$TEMP_DIR/bot.zip" "$ZIP_URL" || {
        echo -e "\e[91mError: Failed to download bot files.\033[0m"
        exit 1
    }
    unzip "$TEMP_DIR/bot.zip" -d "$TEMP_DIR" || {
        echo -e "\e[91mError: Failed to unzip bot files.\033[0m"
        exit 1
    }
    EXTRACTED_DIR=$(find "$TEMP_DIR" -mindepth 1 -maxdepth 1 -type d)
    mv "$EXTRACTED_DIR"/* "$BOT_DIR" || {
        echo -e "\e[91mError: Failed to move bot files.\033[0m"
        exit 1
    }
    rm -rf "$TEMP_DIR"

    sudo chown -R www-data:www-data "$BOT_DIR"
    sudo chmod -R 755 "$BOT_DIR"
    echo -e "\e[92mBot files installed in $BOT_DIR.\033[0m"
    sleep 3
    clear

    # Configure Apache to use port 80 temporarily and 88 for HTTPS
    echo -e "\e[32mConfiguring Apache ports...\033[0m"
    sudo bash -c "echo -n > /etc/apache2/ports.conf"  # Clear the file
    cat <<EOF | sudo tee /etc/apache2/ports.conf
# If you just change the port or add more ports here, you will likely also
# have to change the VirtualHost statement in
# /etc/apache2/sites-enabled/000-default.conf

Listen 80
Listen 88

# vim: syntax=apache ts=4 sw=4 sts=4 sr noet
EOF
    if [ $? -ne 0 ]; then
        echo -e "\e[91mError: Failed to configure ports.conf.\033[0m"
        exit 1
    fi

    # Clear and configure VirtualHost for port 80
    sudo bash -c "echo -n > /etc/apache2/sites-available/000-default.conf"  # Clear the file
    cat <<EOF | sudo tee /etc/apache2/sites-available/000-default.conf
<VirtualHost *:80>
    ServerAdmin webmaster@localhost
    DocumentRoot /var/www/html
    ErrorLog \${APACHE_LOG_DIR}/error.log
    CustomLog \${APACHE_LOG_DIR}/access.log combined
</VirtualHost>

# vim: syntax=apache ts=4 sw=4 sts=4 sr noet
EOF
    if [ $? -ne 0 ]; then
        echo -e "\e[91mError: Failed to configure 000-default.conf.\033[0m"
        exit 1
    fi

    # Enable Apache and apply port changes
    sudo systemctl enable apache2 || {
        echo -e "\e[91mError: Failed to enable Apache2.\033[0m"
        exit 1
    }
    sudo systemctl restart apache2 || {
        echo -e "\e[91mError: Failed to restart Apache2.\033[0m"
        exit 1
    }

    # SSL setup on port 88
    echo -e "\e[32mConfiguring SSL on port 88...\033[0m\n"
    sudo ufw allow 80 || {
        echo -e "\e[91mError: Failed to configure firewall for port 80.\033[0m"
        exit 1
    }
    sudo ufw allow 88 || {
        echo -e "\e[91mError: Failed to configure firewall for port 88.\033[0m"
        exit 1
    }
    clear
    printf "\e[33m[+] \e[36mEnter the domain (e.g., example.com): \033[0m"
    read domainname
    while [[ ! "$domainname" =~ ^[a-zA-Z0-9.-]+$ ]]; do
        echo -e "\e[91mInvalid domain format. Must be like 'example.com'. Please try again.\033[0m"
        printf "\e[33m[+] \e[36mEnter the domain (e.g., example.com): \033[0m"
        read domainname
    done
    DOMAIN_NAME="$domainname"
    echo -e "\e[92mDomain set to: $DOMAIN_NAME\033[0m"

    sudo systemctl restart apache2 || {
        echo -e "\e[91mError: Failed to restart Apache2 before Certbot.\033[0m"
        exit 1
    }
    sudo certbot --apache --agree-tos --preferred-challenges http -d "$DOMAIN_NAME" --https-port 88 --no-redirect || {
        echo -e "\e[91mError: Failed to configure SSL with Certbot on port 88.\033[0m"
        exit 1
    }

    # Ensure SSL VirtualHost uses port 88 with correct settings
    sudo bash -c "echo -n > /etc/apache2/sites-available/000-default-le-ssl.conf"  # Clear any existing file
    cat <<EOF | sudo tee /etc/apache2/sites-available/000-default-le-ssl.conf
<IfModule mod_ssl.c>
<VirtualHost *:88>
    ServerAdmin webmaster@localhost
    ServerName $DOMAIN_NAME
    DocumentRoot /var/www/html
    ErrorLog \${APACHE_LOG_DIR}/error.log
    CustomLog \${APACHE_LOG_DIR}/access.log combined
    SSLEngine on
    SSLCertificateFile /etc/letsencrypt/live/$DOMAIN_NAME/fullchain.pem
    SSLCertificateKeyFile /etc/letsencrypt/live/$DOMAIN_NAME/privkey.pem
    SSLProtocol all -SSLv2 -SSLv3 -TLSv1 -TLSv1.1
    SSLCipherSuite HIGH:!aNULL:!MD5
</VirtualHost>
</IfModule>
EOF
    if [ $? -ne 0 ]; then
        echo -e "\e[91mError: Failed to create SSL VirtualHost configuration.\033[0m"
        exit 1
    fi
    sudo a2enmod ssl || {
        echo -e "\e[91mError: Failed to enable SSL module.\033[0m"
        exit 1
    }
    sudo a2ensite 000-default-le-ssl.conf || {
        echo -e "\e[91mError: Failed to enable SSL site.\033[0m"
        exit 1
    }
    # Force ports.conf to only listen on 88 before restarting Apache
    sudo bash -c "echo -n > /etc/apache2/ports.conf"
    cat <<EOF | sudo tee /etc/apache2/ports.conf
Listen 88
EOF
    sudo apache2ctl configtest || {
        echo -e "\e[91mError: Apache configuration test failed.\033[0m"
        exit 1
    }
    sudo systemctl restart apache2 || {
        echo -e "\e[91mError: Failed to restart Apache2 after SSL configuration.\033[0m"
        systemctl status apache2.service
        exit 1
    }

    # Disable port 80 after SSL is configured
    echo -e "\e[32mDisabling port 80 as it's no longer needed...\033[0m"
    sudo a2dissite 000-default.conf || {
        echo -e "\e[91mError: Failed to disable port 80 VirtualHost.\033[0m"
        exit 1
    }
    sudo ufw delete allow 80 || {
        echo -e "\e[91mError: Failed to remove port 80 from firewall.\033[0m"
        exit 1
    }
    sudo apache2ctl configtest || {
        echo -e "\e[91mError: Apache configuration test failed.\033[0m"
        exit 1
    }
    sudo systemctl restart apache2 || {
        echo -e "\e[91mError: Failed to restart Apache2 after disabling port 80.\033[0m"
        systemctl status apache2.service
        exit 1
    }
    echo -e "\e[92mSSL configured successfully on port 88. Port 80 disabled.\033[0m"
    sleep 3
    clear

    # Bot token, chat ID, and username
    printf "\e[33m[+] \e[36mBot Token: \033[0m"
    read YOUR_BOT_TOKEN
    while [[ ! "$YOUR_BOT_TOKEN" =~ ^[0-9]{8,10}:[a-zA-Z0-9_-]{35}$ ]]; do
        echo -e "\e[91mInvalid bot token format. Please try again.\033[0m"
        printf "\e[33m[+] \e[36mBot Token: \033[0m"
        read YOUR_BOT_TOKEN
    done

    printf "\e[33m[+] \e[36mChat id: \033[0m"
    read YOUR_CHAT_ID
    while [[ ! "$YOUR_CHAT_ID" =~ ^-?[0-9]+$ ]]; do
        echo -e "\e[91mInvalid chat ID format. Please try again.\033[0m"
        printf "\e[33m[+] \e[36mChat id: \033[0m"
        read YOUR_CHAT_ID
    done

    YOUR_DOMAIN="$DOMAIN_NAME:88"  # Use port 88 for HTTPS
    printf "\e[33m[+] \e[36mUsernamebot: \033[0m"
    read YOUR_BOTNAME
    while [ -z "$YOUR_BOTNAME" ]; do
        echo -e "\e[91mError: Bot username cannot be empty.\033[0m"
        printf "\e[33m[+] \e[36mUsernamebot: \033[0m"
        read YOUR_BOTNAME
    done

    # Create config file with correct MySQL host and PDO
    ASAS="$"
    secrettoken=$(openssl rand -base64 10 | tr -dc 'a-zA-Z0-9' | cut -c1-8)
    cat <<EOF > "$BOT_DIR/config.php"
<?php
${ASAS}APIKEY = '$YOUR_BOT_TOKEN';
${ASAS}usernamedb = '$dbuser';
${ASAS}passworddb = '$dbpass';
${ASAS}dbname = '$dbname';
${ASAS}domainhosts = '$YOUR_DOMAIN/$bot_folder_name';
${ASAS}adminnumber = '$YOUR_CHAT_ID';
${ASAS}usernamebot = '$YOUR_BOTNAME';
${ASAS}secrettoken = '$secrettoken';

${ASAS}connect = mysqli_connect('127.0.0.1', \$usernamedb, \$passworddb, \$dbname);
if (${ASAS}connect->connect_error) {
    die('Database connection failed: ' . ${ASAS}connect->connect_error);
}
mysqli_set_charset(${ASAS}connect, 'utf8mb4');

${ASAS}options = [
    PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
    PDO::ATTR_EMULATE_PREPARES   => false,
];
${ASAS}dsn = "mysql:host=127.0.0.1;port=3306;dbname=\$dbname;charset=utf8mb4";
try {
    ${ASAS}pdo = new PDO(\$dsn, \$usernamedb, \$passworddb, \$options);
} catch (\PDOException \$e) {
    die('PDO Connection failed: ' . \$e->getMessage());
}
?>
EOF

    # Set webhook with port 88
    curl -F "url=https://${YOUR_DOMAIN}/$bot_folder_name/index.php" \
         -F "secret_token=${secrettoken}" \
         "https://api.telegram.org/bot${YOUR_BOT_TOKEN}/setWebhook" || {
        echo -e "\e[91mError: Failed to set webhook.\033[0m"
        exit 1
    }

    # Send confirmation message
    MESSAGE="? The bot is installed! For start bot send /start command."
    curl -s -X POST "https://api.telegram.org/bot${YOUR_BOT_TOKEN}/sendMessage" -d chat_id="${YOUR_CHAT_ID}" -d text="$MESSAGE" || {
        echo -e "\e[91mError: Failed to send message to Telegram.\033[0m"
        exit 1
    }

    # Execute table creation script
    TABLE_SETUP_URL="https://${YOUR_DOMAIN}/$bot_folder_name/table.php"
    echo -e "\e[33mSetting up database tables...\033[0m"
    curl $TABLE_SETUP_URL || {
        echo -e "\e[91mError: Failed to execute table creation script at $TABLE_SETUP_URL.\033[0m"
        exit 1
    }

    # Output Bot Information
    echo -e "\e[32mBot installed successfully!\033[0m"
    echo -e "\e[102mDomain Bot: https://${YOUR_DOMAIN}/$bot_folder_name\033[0m"
    echo -e "\e[104mDatabase address: https://${YOUR_DOMAIN}/phpmyadmin\033[0m"
    echo -e "\e[33mDatabase name: \e[36m$dbname\033[0m"
    echo -e "\e[33mDatabase username: \e[36m$dbuser\033[0m"
    echo -e "\e[33mDatabase password: \e[36m$dbpass\033[0m"
    echo -e "\e[33mBot folder: \e[36m$bot_folder_name\033[0m"

    # Add executable permission and link
    chmod +x /root/install.sh
    ln -vs /root/install.sh /usr/local/bin/mirza
}
# Update Function
# Update Function
function update_bot() {
    echo -e "\033[36mBot Update Tool\033[0m"

    # List all available bots in /var/www/html
    echo -e "\033[36mAvailable Bots:\033[0m"
    BOT_DIRS=$(ls -d /var/www/html/*/ 2>/dev/null | xargs -n 1 basename)

    if [ -z "$BOT_DIRS" ]; then
        echo -e "\033[31mNo bots found in /var/www/html.\033[0m"
        return 1
    fi

    echo "$BOT_DIRS" | nl -w 2 -s ") "

    # Prompt user to select a bot
    echo -ne "\033[36mEnter the bot name: \033[0m"
    read SELECTED_BOT

    # Validate selected bot
    if [[ ! "$BOT_DIRS" =~ (^|[[:space:]])$SELECTED_BOT($|[[:space:]]) ]]; then
        echo -e "\033[31mInvalid bot name. Please select from the list above.\033[0m"
        return 1
    fi

    # Set bot directory and config path
    BOT_DIR="/var/www/html/$SELECTED_BOT"
    CONFIG_PATH="$BOT_DIR/config.php"

    # Check if bot is already installed
    if [ ! -d "$BOT_DIR" ]; then
        echo -e "\033[91mError: Bot '$SELECTED_BOT' is not installed.\033[0m"
        return 1
    fi

    if [ ! -f "$CONFIG_PATH" ]; then
        echo -e "\033[91mError: Config file not found for bot '$SELECTED_BOT'.\033[0m"
        return 1
    fi

    echo -e "\033[33mUpdating $SELECTED_BOT...\033[0m"

    # Update server packages
    echo -e "\033[33mUpdating server packages...\033[0m"
    if ! sudo apt update && sudo apt upgrade -y; then
        echo -e "\033[91mError updating the server. Exiting...\033[0m"
        return 1
    fi
    echo -e "\033[92mServer packages updated successfully...\033[0m\n"

    # Fetch latest release from GitHub
    ZIP_URL="https://github.com/Mmdd93/mirza_pro/archive/refs/heads/main.zip"

    # Create temporary directory
    TEMP_DIR="/tmp/mirzabot_update_$SELECTED_BOT"
    mkdir -p "$TEMP_DIR"

    # Download and extract
    echo -e "\033[33mDownloading update package...\033[0m"
    wget -O "$TEMP_DIR/bot.zip" "$ZIP_URL" || {
        echo -e "\033[91mError: Failed to download update package.\033[0m"
        return 1
    }

    echo -e "\033[33mExtracting update package...\033[0m"
    unzip -q "$TEMP_DIR/bot.zip" -d "$TEMP_DIR" || {
        echo -e "\033[91mError: Failed to extract update package.\033[0m"
        return 1
    }

    # Find extracted directory
    EXTRACTED_DIR=$(find "$TEMP_DIR" -mindepth 1 -maxdepth 1 -type d)
    if [ -z "$EXTRACTED_DIR" ]; then
        echo -e "\033[91mError: No extracted directory found.\033[0m"
        return 1
    fi

    # Temporarily move config.php to safe location
    echo -e "\033[33mPreserving config.php...\033[0m"
    TEMP_CONFIG="/tmp/config_${SELECTED_BOT}.php"
    sudo mv "$CONFIG_PATH" "$TEMP_CONFIG" || {
        echo -e "\033[91mFailed to move config.php!\033[0m"
        return 1
    }

    # Remove old version files (but keep the directory)
    echo -e "\033[33mRemoving old bot files...\033[0m"
    find "$BOT_DIR" -mindepth 1 -maxdepth 1 -exec rm -rf {} + || {
        echo -e "\033[91mFailed to remove old bot files!\033[0m"
        # Try to restore config.php if removal fails
        sudo mv "$TEMP_CONFIG" "$CONFIG_PATH" 2>/dev/null
        return 1
    }

    # Move new files
    echo -e "\033[33mInstalling new version...\033[0m"
    sudo mv "$EXTRACTED_DIR"/* "$BOT_DIR/" || {
        echo -e "\033[91mFile transfer failed!\033[0m"
        # Try to restore config.php if move fails
        sudo mv "$TEMP_CONFIG" "$CONFIG_PATH" 2>/dev/null
        return 1
    }

    # Restore config.php
    echo -e "\033[33mRestoring config.php...\033[0m"
    sudo mv "$TEMP_CONFIG" "$CONFIG_PATH" || {
        echo -e "\033[91mFailed to restore config.php!\033[0m"
        return 1
    }

    # Set permissions
    echo -e "\033[33mSetting permissions...\033[0m"
    sudo chown -R www-data:www-data "$BOT_DIR/"
    sudo chmod -R 755 "$BOT_DIR/"
    sudo chmod 644 "$CONFIG_PATH" 2>/dev/null

    # Copy the new install.sh to /root/ if updating mirzabotconfig
    if [ "$SELECTED_BOT" = "mirzabotconfig" ] && [ -f "/var/www/html/mirzabotconfig/install.sh" ]; then
        sudo cp /var/www/html/$BOT_DIR/install.sh /root/install.sh
        sudo chmod +x /root/install.sh
        sudo ln -vsf /root/install.sh /usr/local/bin/mirza
        echo -e "\033[92mUpdated /root/install.sh and 'mirza' command.\033[0m"
    fi

   
}

# Remove Mirza Bot (any instance) with interactive options
function remove_bot() {
    echo -e "\e[33mStarting Mirza Bot removal process...\033[0m"
    

    

 echo -e "\e[33mStarting Mirza Bot removal process...\033[0m"
    LOG_FILE="/var/log/remove_bot.log"
    echo "Log file: $LOG_FILE" > "$LOG_FILE"

    # Detect all bot directories in /var/www/html (exclude system folders)
    BOT_DIRS=()
    for dir in /var/www/html/*/; do
        [ -d "$dir" ] || continue
        base=$(basename "$dir")
        if [[ "$base" != "html" && "$base" != "cgi-bin" ]]; then
            BOT_DIRS+=("$base")
        fi
    done

    # Add default directory if exists
    if [ -d "/var/www/html/mirzabotconfig" ] && [[ ! " ${BOT_DIRS[@]} " =~ " mirzabotconfig " ]]; then
        BOT_DIRS+=("mirzabotconfig")
    fi

    if [ ${#BOT_DIRS[@]} -eq 0 ]; then
        echo -e "\e[31mNo Mirza Bot installations found in /var/www/html.\033[0m" | tee -a "$LOG_FILE"
        read -p "Do you want to remove system dependencies anyway? (yes/no): " REMOVE_DEP
        if [[ "$REMOVE_DEP" == "yes" ]]; then
            # Remove dependencies even if no bots
            echo -e "\e[33mRemoving system dependencies...\033[0m"
            # Delete MySQL and Database Data
    echo -e "\e[33mRemoving MySQL and database...\033[0m" | tee -a "$LOG_FILE"
    sudo systemctl stop mysql
    sudo systemctl disable mysql
    sudo systemctl daemon-reload

    sudo apt --fix-broken install -y

    sudo apt-get purge -y mysql-server mysql-client mysql-common mysql-server-core-* mysql-client-core-*
    sudo rm -rf /etc/mysql /var/lib/mysql /var/log/mysql /var/log/mysql.* /usr/lib/mysql /usr/include/mysql /usr/share/mysql
    sudo rm /lib/systemd/system/mysql.service
    sudo rm /etc/init.d/mysql

    sudo dpkg --remove --force-remove-reinstreq mysql-server mysql-server-8.0

    sudo find /etc/systemd /lib/systemd /usr/lib/systemd -name "*mysql*" -exec rm -f {} \;

    sudo apt-get purge -y mysql-server mysql-server-8.0 mysql-client mysql-client-8.0
    sudo apt-get purge -y mysql-client-core-8.0 mysql-server-core-8.0 mysql-common php-mysql php8.2-mysql php8.3-mysql php-mariadb-mysql-kbs

    sudo apt-get autoremove --purge -y
    sudo apt-get clean
    sudo apt-get update

    echo -e "\e[92mMySQL has been completely removed.\033[0m" | tee -a "$LOG_FILE"

    # Delete PHPMyAdmin
    echo -e "\e[33mRemoving PHPMyAdmin...\033[0m" | tee -a "$LOG_FILE"
    if dpkg -s phpmyadmin &>/dev/null; then
        sudo apt-get purge -y phpmyadmin && echo -e "\e[92mPHPMyAdmin removed.\033[0m" | tee -a "$LOG_FILE"
        sudo apt-get autoremove -y && sudo apt-get autoclean -y
    else
        echo -e "\e[93mPHPMyAdmin is not installed.\033[0m" | tee -a "$LOG_FILE"
    fi

    # Remove Apache
    echo -e "\e[33mRemoving Apache...\033[0m" | tee -a "$LOG_FILE"
    sudo systemctl stop apache2 || {
        echo -e "\e[91mFailed to stop Apache. Continuing anyway...\033[0m" | tee -a "$LOG_FILE"
    }
    sudo systemctl disable apache2 || {
        echo -e "\e[91mFailed to disable Apache. Continuing anyway...\033[0m" | tee -a "$LOG_FILE"
    }
    sudo apt-get purge -y apache2 apache2-utils apache2-bin apache2-data libapache2-mod-php* || {
        echo -e "\e[91mFailed to purge Apache packages.\033[0m" | tee -a "$LOG_FILE"
    }
    sudo apt-get autoremove --purge -y
    sudo apt-get autoclean -y
    sudo rm -rf /etc/apache2 /var/www/html

    # Delete Apache and PHP Settings
    echo -e "\e[33mRemoving Apache and PHP configurations...\033[0m" | tee -a "$LOG_FILE"
    sudo a2disconf phpmyadmin.conf &>/dev/null
    sudo rm -f /etc/apache2/conf-available/phpmyadmin.conf
    sudo systemctl restart apache2

    # Remove Unnecessary Packages
    echo -e "\e[33mRemoving additional packages...\033[0m" | tee -a "$LOG_FILE"
    sudo apt-get remove -y php-soap php-ssh2 libssh2-1-dev libssh2-1 \
        && echo -e "\e[92mRemoved additional PHP packages.\033[0m" | tee -a "$LOG_FILE" || echo -e "\e[93mSome additional PHP packages may not be installed.\033[0m" | tee -a "$LOG_FILE"

    # Reset Firewall (without changing SSL rules)
    echo -e "\e[33mResetting firewall rules (except SSL)...\033[0m" | tee -a "$LOG_FILE"
    sudo ufw delete allow 'Apache'
    sudo ufw reload
            echo -e "\e[32mSystem dependencies removed.\033[0m"
        fi
        return 0
    fi

# Check if Marzban is installed and redirect to appropriate function
    if check_marzban_installed; then
        echo -e "\e[41m[IMPORTANT NOTICE]\033[0m \e[33mMarzban detected. Proceeding with Marzban-compatible removal.\033[0m" | tee -a "$LOG_FILE"
        remove_bot_with_marzban
        return 0
    fi
    
# Display available bots
echo -e "\e[36mAvailable Bots:\033[0m"
for i in "${!BOT_DIRS[@]}"; do
    printf "%2d) %s\n" $((i+1)) "${BOT_DIRS[i]}"
done




    # Ask user which bot to remove
    read -p "Enter the bot name to remove: " SELECTED_BOT
    BOT_PATH="/var/www/html/$SELECTED_BOT"
    CONFIG_PATH="$BOT_PATH/config.php"

    if [[ ! "$BOT_DIRS" =~ (^|[[:space:]])$SELECTED_BOT($|[[:space:]]) ]]; then
        echo -e "\e[31mInvalid bot name. Exiting.\033[0m" | tee -a "$LOG_FILE"
        return 1
    fi

    # Ask which components to remove
    read -p "Do you want to remove the bot directory? (yes/no): " REMOVE_DIR


    # Remove bot folder
    if [[ "$REMOVE_DIR" == "yes" && -d "$BOT_PATH" ]]; then
        echo -e "\e[33mRemoving bot directory $BOT_PATH...\033[0m" | tee -a "$LOG_FILE"
        rm -rf "$BOT_PATH" && echo -e "\e[32mBot directory removed successfully.\033[0m" | tee -a "$LOG_FILE"
    fi

     # Delete MySQL and Database Data
    echo -e "\e[33mRemoving MySQL and database...\033[0m" | tee -a "$LOG_FILE"
    sudo systemctl stop mysql
    sudo systemctl disable mysql
    sudo systemctl daemon-reload

    sudo apt --fix-broken install -y

    sudo apt-get purge -y mysql-server mysql-client mysql-common mysql-server-core-* mysql-client-core-*
    sudo rm -rf /etc/mysql /var/lib/mysql /var/log/mysql /var/log/mysql.* /usr/lib/mysql /usr/include/mysql /usr/share/mysql
    sudo rm /lib/systemd/system/mysql.service
    sudo rm /etc/init.d/mysql

    sudo dpkg --remove --force-remove-reinstreq mysql-server mysql-server-8.0

    sudo find /etc/systemd /lib/systemd /usr/lib/systemd -name "*mysql*" -exec rm -f {} \;

    sudo apt-get purge -y mysql-server mysql-server-8.0 mysql-client mysql-client-8.0
    sudo apt-get purge -y mysql-client-core-8.0 mysql-server-core-8.0 mysql-common php-mysql php8.2-mysql php8.3-mysql php-mariadb-mysql-kbs

    sudo apt-get autoremove --purge -y
    sudo apt-get clean
    sudo apt-get update

    echo -e "\e[92mMySQL has been completely removed.\033[0m" | tee -a "$LOG_FILE"

    # Delete PHPMyAdmin
    echo -e "\e[33mRemoving PHPMyAdmin...\033[0m" | tee -a "$LOG_FILE"
    if dpkg -s phpmyadmin &>/dev/null; then
        sudo apt-get purge -y phpmyadmin && echo -e "\e[92mPHPMyAdmin removed.\033[0m" | tee -a "$LOG_FILE"
        sudo apt-get autoremove -y && sudo apt-get autoclean -y
    else
        echo -e "\e[93mPHPMyAdmin is not installed.\033[0m" | tee -a "$LOG_FILE"
    fi

    # Remove Apache
    echo -e "\e[33mRemoving Apache...\033[0m" | tee -a "$LOG_FILE"
    sudo systemctl stop apache2 || {
        echo -e "\e[91mFailed to stop Apache. Continuing anyway...\033[0m" | tee -a "$LOG_FILE"
    }
    sudo systemctl disable apache2 || {
        echo -e "\e[91mFailed to disable Apache. Continuing anyway...\033[0m" | tee -a "$LOG_FILE"
    }
    sudo apt-get purge -y apache2 apache2-utils apache2-bin apache2-data libapache2-mod-php* || {
        echo -e "\e[91mFailed to purge Apache packages.\033[0m" | tee -a "$LOG_FILE"
    }
    sudo apt-get autoremove --purge -y
    sudo apt-get autoclean -y
    sudo rm -rf /etc/apache2 /var/www/html

    # Delete Apache and PHP Settings
    echo -e "\e[33mRemoving Apache and PHP configurations...\033[0m" | tee -a "$LOG_FILE"
    sudo a2disconf phpmyadmin.conf &>/dev/null
    sudo rm -f /etc/apache2/conf-available/phpmyadmin.conf
    sudo systemctl restart apache2

    # Remove Unnecessary Packages
    echo -e "\e[33mRemoving additional packages...\033[0m" | tee -a "$LOG_FILE"
    sudo apt-get remove -y php-soap php-ssh2 libssh2-1-dev libssh2-1 \
        && echo -e "\e[92mRemoved additional PHP packages.\033[0m" | tee -a "$LOG_FILE" || echo -e "\e[93mSome additional PHP packages may not be installed.\033[0m" | tee -a "$LOG_FILE"

    # Reset Firewall (without changing SSL rules)
    echo -e "\e[33mResetting firewall rules (except SSL)...\033[0m" | tee -a "$LOG_FILE"
    sudo ufw delete allow 'Apache'
    sudo ufw reload

    echo -e "\e[92mMirza Bot, MySQL, and their dependencies have been completely removed.\033[0m" | tee -a "$LOG_FILE"
}




function remove_bot_with_marzban() {
    echo -e "\e[33mRemoving Mirza Bot alongside Marzban...\033[0m" | tee -a "$LOG_FILE"

    # Detect all bot directories in /var/www/html excluding system folders
    BOT_DIRS=$(ls -d /var/www/html/*/ 2>/dev/null | grep -vE "(html|cgi-bin)" | xargs -n 1 basename)
    if [ -z "$BOT_DIRS" ]; then
        echo -e "\e[93mNo additional bot directories detected. Using default folder 'mirzabotconfig'.\033[0m" | tee -a "$LOG_FILE"
        BOT_DIR="mirzabotconfig"
    else
        echo -e "\e[36mAvailable bot directories:\033[0m"
        echo "$BOT_DIRS" | nl -w 2 -s ") "
        read -p "Enter the bot folder to remove (default: mirzabotconfig): " SELECTED_BOT
        BOT_DIR=${SELECTED_BOT:-mirzabotconfig}
    fi

    BOT_PATH="/var/www/html/$BOT_DIR"
    CONFIG_PATH="$BOT_PATH/config.php"

    # Check if Bot Directory exists before proceeding
    if [ ! -d "$BOT_PATH" ]; then
        echo -e "\e[93mWarning: Bot directory $BOT_PATH not found. Assuming it was already removed.\033[0m" | tee -a "$LOG_FILE"
        DB_NAME="mirzabot"  # Fallback to default database name
        DB_USER=""
    else
        # Get database credentials from config.php BEFORE removing the directory
        if [ -f "$CONFIG_PATH" ]; then
            DB_USER=$(grep '^\$usernamedb' "$CONFIG_PATH" | awk -F"'" '{print $2}')
            DB_NAME=$(grep '^\$dbname' "$CONFIG_PATH" | awk -F"'" '{print $2}')
            DB_USER=${DB_USER:-""}
            DB_NAME=${DB_NAME:-"mirzabot"}
            echo -e "\e[92mFound database credentials: User=$DB_USER, Database=$DB_NAME\033[0m" | tee -a "$LOG_FILE"
        else
            echo -e "\e[93mconfig.php not found. Using default database 'mirzabot'.\033[0m" | tee -a "$LOG_FILE"
            DB_NAME="mirzabot"
            DB_USER=""
        fi

        # Now remove the Bot Directory
        sudo rm -rf "$BOT_PATH" && echo -e "\e[92mBot directory removed: $BOT_PATH\033[0m" | tee -a "$LOG_FILE" || {
            echo -e "\e[91mFailed to remove bot directory: $BOT_PATH. Exiting...\033[0m" | tee -a "$LOG_FILE"
            exit 1
        }
    fi

    # Get MySQL root password from Marzban's .env
    ENV_FILE="/opt/marzban/.env"
    if [ -f "$ENV_FILE" ]; then
        MYSQL_ROOT_PASSWORD=$(grep "MYSQL_ROOT_PASSWORD=" "$ENV_FILE" | cut -d'=' -f2 | tr -d '[:space:]' | sed 's/"//g')
        ROOT_USER="root"
    else
        echo -e "\e[91mError: Marzban .env file not found. Cannot proceed without MySQL root password.\033[0m" | tee -a "$LOG_FILE"
        exit 1
    fi

    # Find MySQL container
    MYSQL_CONTAINER=$(docker ps -q --filter "name=mysql" --no-trunc)
    if [ -z "$MYSQL_CONTAINER" ]; then
        echo -e "\e[91mError: Could not find a running MySQL container. Ensure Marzban is running.\033[0m" | tee -a "$LOG_FILE"
        exit 1
    fi

    # Remove database
    if [ -n "$DB_NAME" ]; then
        echo -e "\e[33mRemoving database $DB_NAME...\033[0m" | tee -a "$LOG_FILE"
        docker exec "$MYSQL_CONTAINER" bash -c "mysql -u '$ROOT_USER' -p'$MYSQL_ROOT_PASSWORD' -e \"DROP DATABASE IF EXISTS $DB_NAME;\"" && {
            echo -e "\e[92mDatabase $DB_NAME removed successfully.\033[0m" | tee -a "$LOG_FILE"
        } || {
            echo -e "\e[91mFailed to remove database $DB_NAME.\033[0m" | tee -a "$LOG_FILE"
        }
    fi

    # Remove user if DB_USER is available
    if [ -n "$DB_USER" ]; then
        echo -e "\e[33mRemoving database user $DB_USER...\033[0m" | tee -a "$LOG_FILE"
        docker exec "$MYSQL_CONTAINER" bash -c "mysql -u '$ROOT_USER' -p'$MYSQL_ROOT_PASSWORD' -e \"DROP USER IF EXISTS '$DB_USER'@'%'; FLUSH PRIVILEGES;\"" && {
            echo -e "\e[92mUser $DB_USER removed successfully.\033[0m" | tee -a "$LOG_FILE"
        } || {
            echo -e "\e[91mFailed to remove user $DB_USER.\033[0m" | tee -a "$LOG_FILE"
        }
    else
        echo -e "\e[93mWarning: No database user specified. Checking for non-default users...\033[0m" | tee -a "$LOG_FILE"
        # Check for non-default users
        MIRZA_USERS=$(docker exec "$MYSQL_CONTAINER" bash -c "mysql -u '$ROOT_USER' -p'$MYSQL_ROOT_PASSWORD' -e \"SELECT User FROM mysql.user WHERE User NOT IN ('root', 'mysql.infoschema', 'mysql.session', 'mysql.sys', 'marzban');\"" | grep -v "User" | awk '{print $1}')
        if [ -n "$MIRZA_USERS" ]; then
            for user in $MIRZA_USERS; do
                echo -e "\e[33mRemoving detected non-default user: $user...\033[0m" | tee -a "$LOG_FILE"
                docker exec "$MYSQL_CONTAINER" bash -c "mysql -u '$ROOT_USER' -p'$MYSQL_ROOT_PASSWORD' -e \"DROP USER IF EXISTS '$user'@'%'; FLUSH PRIVILEGES;\"" && {
                    echo -e "\e[92mUser $user removed successfully.\033[0m" | tee -a "$LOG_FILE"
                } || {
                    echo -e "\e[91mFailed to remove user $user.\033[0m" | tee -a "$LOG_FILE"
                }
            done
        else
            echo -e "\e[93mNo non-default users found.\033[0m" | tee -a "$LOG_FILE"
        fi
    fi

    # Remove Apache
    echo -e "\e[33mRemoving Apache...\033[0m" | tee -a "$LOG_FILE"
    sudo systemctl stop apache2 || {
        echo -e "\e[91mFailed to stop Apache. Continuing anyway...\033[0m" | tee -a "$LOG_FILE"
    }
    sudo systemctl disable apache2 || {
        echo -e "\e[91mFailed to disable Apache. Continuing anyway...\033[0m" | tee -a "$LOG_FILE"
    }
    sudo apt-get purge -y apache2 apache2-utils apache2-bin apache2-data libapache2-mod-php* || {
        echo -e "\e[91mFailed to purge Apache packages.\033[0m" | tee -a "$LOG_FILE"
    }
    sudo apt-get autoremove --purge -y
    sudo apt-get autoclean -y
    sudo rm -rf /etc/apache2 /var/www/html

    # Reset Firewall (only remove Apache rule, keep SSL)
    echo -e "\e[33mResetting firewall rules (keeping SSL)...\033[0m" | tee -a "$LOG_FILE"
    sudo ufw delete allow 'Apache' || {
        echo -e "\e[91mFailed to remove Apache rule from UFW.\033[0m" | tee -a "$LOG_FILE"
    }
    sudo ufw reload

    echo -e "\e[92mMirza Bot has been removed alongside Marzban. SSL certificates remain intact.\033[0m" | tee -a "$LOG_FILE"
}

# Extract database credentials from config.php with bot selection
function extract_db_credentials() {
    # List available bots
    echo -e "\033[36mAvailable Bots:\033[0m"
    BOT_DIRS=$(ls -d /var/www/html/*/ 2>/dev/null | grep -v "/var/www/html/mirzabotconfig" | xargs -n 1 basename)

    if [ -z "$BOT_DIRS" ]; then
        echo -e "\033[31mNo additional bots found in /var/www/html.\033[0m"
        return 1
    fi

    # Display bots with numbers
    echo "$BOT_DIRS" | nl -w 2 -s ") "

    # Prompt for bot selection
    echo -ne "\033[36mEnter the bot name: \033[0m"
    read SELECTED_BOT

    # Validate selected bot
    if [[ ! "$BOT_DIRS" =~ (^|[[:space:]])$SELECTED_BOT($|[[:space:]]) ]]; then
        echo -e "\033[31mInvalid bot name. Please select from the list above.\033[0m"
        return 1
    fi

    # Set config path for selected bot
    CONFIG_PATH="/var/www/html/$SELECTED_BOT/config.php"
    
    if [ ! -f "$CONFIG_PATH" ]; then
        echo -e "\033[31m[ERROR]\033[0m config.php not found at $CONFIG_PATH."
        return 1
    fi

    echo -e "\033[33mExtracting credentials from $CONFIG_PATH...\033[0m"

    # Extract credentials
    DB_USER=$(grep '^\$usernamedb' "$CONFIG_PATH" | awk -F"'" '{print $2}')
    DB_PASS=$(grep '^\$passworddb' "$CONFIG_PATH" | awk -F"'" '{print $2}')
    DB_NAME=$(grep '^\$dbname' "$CONFIG_PATH" | awk -F"'" '{print $2}')
    TELEGRAM_TOKEN=$(grep '^\$APIKEY' "$CONFIG_PATH" | awk -F"'" '{print $2}')
    TELEGRAM_CHAT_ID=$(grep '^\$adminnumber' "$CONFIG_PATH" | awk -F"'" '{print $2}')

    # Validate extracted credentials
    if [ -z "$DB_USER" ] || [ -z "$DB_PASS" ] || [ -z "$DB_NAME" ]; then
        echo -e "\033[31m[ERROR]\033[0m Failed to extract required database credentials from $CONFIG_PATH."
        echo -e "\033[33mFound values:\033[0m"
        echo -e "  DB User: ${DB_USER:-Not found}"
        echo -e "  DB Pass: ${DB_PASS:0:2}****** (hidden)"
        echo -e "  DB Name: ${DB_NAME:-Not found}"
        return 1
    fi

    # Show extracted credentials (with password hidden)
    echo -e "\033[32mCredentials extracted successfully:\033[0m"
    echo -e "  Database: $DB_NAME"
    echo -e "  Username: $DB_USER"
    echo -e "  Password: ${DB_PASS:0:2}******"
    
    if [ -n "$TELEGRAM_TOKEN" ]; then
        echo -e "  Telegram Token: ${TELEGRAM_TOKEN:0:10}******"
    else
        echo -e "  Telegram Token: Not found"
    fi
    
    if [ -n "$TELEGRAM_CHAT_ID" ]; then
        echo -e "  Telegram Chat ID: $TELEGRAM_CHAT_ID"
    else
        echo -e "  Telegram Chat ID: Not found"
    fi

    return 0
}

# Translate cron schedule to human-readable format
function translate_cron() {
    local cron_line="$1"
    local schedule=""
    case "$cron_line" in
        "* * * * *"*) schedule="Every Minute" ;;
        "0 * * * *"*) schedule="Every Hour" ;;
        "0 0 * * *"*) schedule="Every Day" ;;
        "0 0 * * 0"*) schedule="Every Week" ;;
        *) schedule="Custom Schedule ($cron_line)" ;;
    esac
    echo "$schedule"
}


# Export Database Function
function export_database() {
    echo -e "\033[36mDatabase Export Tool\033[0m"

    # List all available bots in /var/www/html
    echo -e "\033[36mAvailable Bots:\033[0m"
    BOT_DIRS=$(ls -d /var/www/html/*/ 2>/dev/null | xargs -n 1 basename)

    if [ -z "$BOT_DIRS" ]; then
        echo -e "\033[31mNo bots found in /var/www/html.\033[0m"
        return 1
    fi

    echo "$BOT_DIRS" | nl -w 2 -s ") "

    # Prompt user to select a bot
    echo -ne "\033[36mEnter the bot name: \033[0m"
    read SELECTED_BOT

    # Validate selected bot
    if [[ ! "$BOT_DIRS" =~ (^|[[:space:]])$SELECTED_BOT($|[[:space:]]) ]]; then
        echo -e "\033[31mInvalid bot name. Please select from the list above.\033[0m"
        return 1
    fi

    # Set config path for selected bot
    CONFIG_FILE="/var/www/html/$SELECTED_BOT/config.php"
    
    if [ ! -f "$CONFIG_FILE" ]; then
        echo -e "\033[31m[ERROR] config.php not found at $CONFIG_FILE\033[0m"
        return 1
    fi

    # Extract credentials from selected bot
    echo -e "\033[33mExtracting credentials from $SELECTED_BOT...\033[0m"
    DB_USER=$(grep '^\$usernamedb' "$CONFIG_FILE" | awk -F"'" '{print $2}')
    DB_PASS=$(grep '^\$passworddb' "$CONFIG_FILE" | awk -F"'" '{print $2}')
    DB_NAME=$(grep '^\$dbname' "$CONFIG_FILE" | awk -F"'" '{print $2}')
    TELEGRAM_TOKEN=$(grep '^\$APIKEY' "$CONFIG_FILE" | awk -F"'" '{print $2}')
    TELEGRAM_CHAT_ID=$(grep '^\$adminnumber' "$CONFIG_FILE" | awk -F"'" '{print $2}')

    if [ -z "$DB_USER" ] || [ -z "$DB_PASS" ] || [ -z "$DB_NAME" ]; then
        echo -e "\033[31m[ERROR] Failed to extract required database credentials from $CONFIG_FILE.\033[0m"
        return 1
    fi

    echo -e "\033[32mCredentials extracted successfully for $SELECTED_BOT\033[0m"
    echo -e "  Database: $DB_NAME"
    echo -e "  Username: $DB_USER"

    # Check if Marzban is installed
    if check_marzban_installed; then
        echo -e "\033[31m[ERROR]\033[0m Exporting database is not supported when Marzban is installed due to database being managed by Docker."
        return 1
    fi

    echo -e "\033[33mVerifying database existence...\033[0m"

    if ! mysql -u "$DB_USER" -p"$DB_PASS" -e "USE $DB_NAME;" 2>/dev/null; then
        echo -e "\033[31m[ERROR]\033[0m Database $DB_NAME does not exist or credentials are incorrect."
        return 1
    fi

    # Create backup directory if it doesn't exist
    BACKUP_DIR="/root/db_backups"
    mkdir -p "$BACKUP_DIR"

    # Generate backup filename with timestamp
    TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
    BACKUP_FILE="$BACKUP_DIR/${DB_NAME}_${SELECTED_BOT}_${TIMESTAMP}.sql"

    # Ask for export options
    echo -e "\033[36mExport Options for $SELECTED_BOT:\033[0m"
    echo -e "  1) Save to local file only"
    if [ -n "$TELEGRAM_TOKEN" ] && [ -n "$TELEGRAM_CHAT_ID" ]; then
        echo -e "  2) Send to Telegram only"
        echo -e "  3) Both (save locally and send to Telegram)"
    else
        echo -e "  2) \033[33mTelegram export not available (missing token or chat ID)\033[0m"
    fi
    echo -e "  4) Cancel export"
    
    echo -ne "\033[36mSelect option [1-4]: \033[0m"
    read EXPORT_OPTION

    case $EXPORT_OPTION in
        1)
            EXPORT_MODE="local"
            ;;
        2)
            if [ -z "$TELEGRAM_TOKEN" ] || [ -z "$TELEGRAM_CHAT_ID" ]; then
                echo -e "\033[31m[ERROR] Telegram export not available. Missing bot token or chat ID.\033[0m"
                return 1
            fi
            EXPORT_MODE="telegram"
            ;;
        3)
            if [ -z "$TELEGRAM_TOKEN" ] || [ -z "$TELEGRAM_CHAT_ID" ]; then
                echo -e "\033[31m[ERROR] Telegram export not available. Missing bot token or chat ID.\033[0m"
                return 1
            fi
            EXPORT_MODE="both"
            ;;
        4)
            echo -e "\033[33mExport cancelled.\033[0m"
            return 0
            ;;
        *)
            echo -e "\033[31mInvalid option. Please try again.\033[0m"
            return 1
            ;;
    esac

    echo -e "\033[33mCreating database backup...\033[0m"
    
    # Show database size for reference
    DB_SIZE=$(mysql -u "$DB_USER" -p"$DB_PASS" -D "$DB_NAME" -s -N -e "
        SELECT ROUND(SUM(data_length + index_length) / 1024 / 1024, 2) 
        FROM information_schema.tables 
        WHERE table_schema = '$DB_NAME'" 2>/dev/null)
    
    echo -e "\033[33mDatabase size: ${DB_SIZE:-0} MB\033[0m"

    # Start time for performance measurement
    START_TIME=$(date +%s)

    # Create the backup
    if ! mysqldump -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" > "$BACKUP_FILE"; then
        echo -e "\033[31m[ERROR]\033[0m Failed to create database backup."
        return 1
    fi

    # Calculate backup time and size
    END_TIME=$(date +%s)
    DURATION=$((END_TIME - START_TIME))
    BACKUP_SIZE=$(du -h "$BACKUP_FILE" | cut -f1)

    echo -e "\033[32mBackup created successfully!\033[0m"
    echo -e "\033[33mBackup details:\033[0m"
    echo -e "  File: $(basename "$BACKUP_FILE")"
    echo -e "  Size: $BACKUP_SIZE"
    echo -e "  Time: ${DURATION} seconds"

    # Handle different export modes
    case $EXPORT_MODE in
        "local")
            echo -e "\033[32mBackup saved locally: $BACKUP_FILE\033[0m"
            ;;
        "telegram")
            echo -e "\033[33mSending backup to Telegram...\033[0m"
            if curl -s -F document=@"$BACKUP_FILE" \
                   -F caption="Database backup for $SELECTED_BOT ($DB_NAME)
File: $(basename "$BACKUP_FILE")
Size: $BACKUP_SIZE
Time: ${DURATION}s
Date: $(date)" \
                   "https://api.telegram.org/bot$TELEGRAM_TOKEN/sendDocument" \
                   -F chat_id="$TELEGRAM_CHAT_ID" > /dev/null; then
                echo -e "\033[32mBackup sent to Telegram successfully!\033[0m"
                # Remove local file if only sending to Telegram
                rm -f "$BACKUP_FILE"
            else
                echo -e "\033[31m[ERROR] Failed to send backup to Telegram.\033[0m"
                echo -e "\033[33mBackup saved locally instead: $BACKUP_FILE\033[0m"
            fi
            ;;
        "both")
            echo -e "\033[33mSending backup to Telegram...\033[0m"
            if curl -s -F document=@"$BACKUP_FILE" \
                   -F caption="Database backup for $SELECTED_BOT ($DB_NAME)
File: $(basename "$BACKUP_FILE")
Size: $BACKUP_SIZE
Time: ${DURATION}s
Date: $(date)" \
                   "https://api.telegram.org/bot$TELEGRAM_TOKEN/sendDocument" \
                   -F chat_id="$TELEGRAM_CHAT_ID" > /dev/null; then
                echo -e "\033[32mBackup sent to Telegram successfully!\033[0m"
                echo -e "\033[32mBackup also saved locally: $BACKUP_FILE\033[0m"
            else
                echo -e "\033[31m[ERROR] Failed to send backup to Telegram.\033[0m"
                echo -e "\033[33mBackup saved locally only: $BACKUP_FILE\033[0m"
            fi
            ;;
    esac

    # Show table count for verification
    TABLE_COUNT=$(mysql -u "$DB_USER" -p"$DB_PASS" -D "$DB_NAME" -s -N -e "SHOW TABLES;" | wc -l)
    echo -e "\033[33mDatabase contains $TABLE_COUNT tables.\033[0m"

    # List recent backups for this bot
    echo -e "\033[33mRecent backups for $SELECTED_BOT:\033[0m"
    ls -la "$BACKUP_DIR" | grep "${SELECTED_BOT}" | tail -5 | awk '{print $6" "$7" "$8" "$9}'
}

# Import Database Function
function import_database() {
    echo -e "\033[33mChecking database configuration...\033[0m"

    if ! extract_db_credentials; then
        return 1
    fi

    # Check if Marzban is installed
    if check_marzban_installed; then
        echo -e "\033[31m[ERROR]\033[0m Importing database is not supported when Marzban is installed due to database being managed by Docker."
        return 1
    fi

    echo -e "\033[33mVerifying database existence...\033[0m"

    if ! mysql -u "$DB_USER" -p"$DB_PASS" -e "USE $DB_NAME;" 2>/dev/null; then
        echo -e "\033[31m[ERROR]\033[0m Database $DB_NAME does not exist or credentials are incorrect."
        return 1
    fi

    while true; do
        echo -ne "\033[36mEnter the path to the backup file [default: /root/${DB_NAME}_backup.sql]: \033[0m"
        read BACKUP_FILE
        BACKUP_FILE=${BACKUP_FILE:-/root/${DB_NAME}_backup.sql}

        if [[ -f "$BACKUP_FILE" && "$BACKUP_FILE" =~ \.sql$ ]]; then
            break
        else
            echo -e "\033[31m[ERROR]\033[0m Invalid file path or format. Please provide a valid .sql file."
            echo -e "\033[33mAvailable .sql files:\033[0m"
            find /root /var/www/html -name "*.sql" -type f 2>/dev/null | head -10
        fi
    done

    # Check if database has existing tables
    echo -e "\033[33mChecking existing database tables...\033[0m"
    EXISTING_TABLES=$(mysql -u "$DB_USER" -p"$DB_PASS" -D "$DB_NAME" -s -N -e "SHOW TABLES;" 2>/dev/null | wc -l)

    if [ "$EXISTING_TABLES" -gt 0 ]; then
        echo -e "\033[33mDatabase $DB_NAME contains $EXISTING_TABLES existing tables.\033[0m"
        echo -e "\033[33mExisting tables:\033[0m"
        mysql -u "$DB_USER" -p"$DB_PASS" -D "$DB_NAME" -e "SHOW TABLES;" 2>/dev/null
        
        # Ask user what to do with existing tables
        echo -e "\033[36mHow do you want to handle existing tables?\033[0m"
        echo -e "  1) Drop all tables before import (WARNING: This will delete all existing data!)"
        echo -e "  2) Skip existing tables (keep current data, import only new tables)"
        echo -e "  3) Abort import operation"
        echo -ne "\033[36mSelect option [1-3]: \033[0m"
        read TABLE_OPTION

        case $TABLE_OPTION in
            1)
                echo -e "\033[31mWARNING: This will DELETE ALL EXISTING DATA in database $DB_NAME!\033[0m"
                echo -ne "\033[36mAre you absolutely sure? (yes/no): \033[0m"
                read CONFIRM_DROP
                if [[ "$CONFIRM_DROP" == "yes" ]]; then
                    echo -e "\033[33mDropping all existing tables...\033[0m"
                    mysql -u "$DB_USER" -p"$DB_PASS" -D "$DB_NAME" -e "
                    SET FOREIGN_KEY_CHECKS = 0;
                    SET GROUP_CONCAT_MAX_LEN=32768;
                    SET @tables = NULL;
                    SELECT GROUP_CONCAT('\`', table_name, '\`') INTO @tables
                    FROM information_schema.tables
                    WHERE table_schema = '$DB_NAME';
                    SELECT IFNULL(@tables,'dummy') INTO @tables;
                    SET @tables = CONCAT('DROP TABLE IF EXISTS ', @tables);
                    PREPARE stmt FROM @tables;
                    EXECUTE stmt;
                    DEALLOCATE PREPARE stmt;
                    SET FOREIGN_KEY_CHECKS = 1;" 2>/tmp/drop_tables_error.log
                    
                    if [ $? -eq 0 ]; then
                        echo -e "\033[32mAll tables dropped successfully.\033[0m"
                    else
                        echo -e "\033[31mError dropping tables. See /tmp/drop_tables_error.log\033[0m"
                        return 1
                    fi
                else
                    echo -e "\033[33mTable drop cancelled. Aborting import.\033[0m"
                    return 1
                fi
                ;;
            2)
                echo -e "\033[33mSkipping existing tables. Only new tables will be imported.\033[0m"
                ;;
            3)
                echo -e "\033[33mImport operation aborted by user.\033[0m"
                return 1
                ;;
            *)
                echo -e "\033[31mInvalid option. Aborting import.\033[0m"
                return 1
                ;;
        esac
    else
        echo -e "\033[32mDatabase is empty. Proceeding with import...\033[0m"
    fi

    # Ask about admin chat ID replacement
    echo -ne "\033[36mDo you want to replace admin ID in admin table with current chat ID ($TELEGRAM_CHAT_ID)? (yes/no): \033[0m"
    read REPLACE_CHAT_ID

    if [[ "$REPLACE_CHAT_ID" == "yes" ]]; then
        echo -e "\033[33mScanning for admin IDs in SQL file...\033[0m"
        
        # Create a temporary modified SQL file
        TEMP_SQL_FILE="/tmp/${DB_NAME}_modified_$(date +%s).sql"
        cp "$BACKUP_FILE" "$TEMP_SQL_FILE"
        
        # Find admin IDs in the admin table INSERT statements
        ADMIN_INSERTS=$(grep -n "INSERT INTO \`admin\`" "$TEMP_SQL_FILE")
        
        if [ -n "$ADMIN_INSERTS" ]; then
            echo -e "\033[33mFound admin table INSERT statements:\033[0m"
            echo "$ADMIN_INSERTS"
            
            # Replace admin IDs in INSERT INTO `admin` statements
            # Format: INSERT INTO `admin` VALUES ('old_id','rule','username','password');
            sed -i "s/INSERT INTO \`admin\` VALUES ('[0-9]*'/INSERT INTO \`admin\` VALUES ('$TELEGRAM_CHAT_ID'/g" "$TEMP_SQL_FILE"
            
            # Also handle different formats like INSERT INTO admin VALUES (...)
            sed -i "s/INSERT INTO admin VALUES ('[0-9]*'/INSERT INTO admin VALUES ('$TELEGRAM_CHAT_ID'/g" "$TEMP_SQL_FILE"
            
            echo -e "\033[32mAdmin ID replaced with $TELEGRAM_CHAT_ID in admin table.\033[0m"
            BACKUP_FILE="$TEMP_SQL_FILE"
        else
            echo -e "\033[33mNo admin table INSERT statements found in SQL file.\033[0m"
            rm -f "$TEMP_SQL_FILE"
        fi
    fi

    # Create backup before import
    TIMESTAMP=$(date '+%Y%m%d_%H%M%S')
    BACKUP_BEFORE_IMPORT="/root/${DB_NAME}_backup_before_import_${TIMESTAMP}.sql"
    
    echo -e "\033[33mCreating backup of current database state...\033[0m"
    if mysqldump -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" > "$BACKUP_BEFORE_IMPORT" 2>/tmp/backup_before_import.log; then
        echo -e "\033[32mBackup created: $BACKUP_BEFORE_IMPORT\033[0m"
    else
        echo -e "\033[31m[WARNING] Failed to create backup before import.\033[0m"
        echo -ne "\033[36mContinue with import anyway? (yes/no): \033[0m"
        read CONTINUE_IMPORT
        if [[ "$CONTINUE_IMPORT" != "yes" ]]; then
            echo -e "\033[33mImport aborted.\033[0m"
            # Clean up temp file if created
            [ -n "$TEMP_SQL_FILE" ] && [ -f "$TEMP_SQL_FILE" ] && rm -f "$TEMP_SQL_FILE"
            return 1
        fi
    fi

    # Perform the import
    echo -e "\033[33mImporting backup from $BACKUP_FILE...\033[0m"
    
    START_TIME=$(date +%s)
    
    if mysql -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" < "$BACKUP_FILE" 2>/tmp/import_error.log; then
        END_TIME=$(date +%s)
        DURATION=$((END_TIME - START_TIME))
        
        echo -e "\033[32mDatabase successfully imported from $BACKUP_FILE.\033[0m"
        echo -e "\033[33mImport completed in ${DURATION} seconds.\033[0m"
        
        # Verify import
        echo -e "\033[33mVerifying import...\033[0m"
        IMPORTED_TABLES=$(mysql -u "$DB_USER" -p"$DB_PASS" -D "$DB_NAME" -s -N -e "SHOW TABLES;" 2>/dev/null | wc -l)
        echo -e "\033[32mDatabase now contains $IMPORTED_TABLES tables.\033[0m"
        
        # Verify admin chat ID was set correctly
        if [[ "$REPLACE_CHAT_ID" == "yes" ]]; then
            echo -e "\033[33mVerifying admin ID in database...\033[0m"
            CURRENT_ADMIN_ID=$(mysql -u "$DB_USER" -p"$DB_PASS" -D "$DB_NAME" -s -N -e "SELECT id_admin FROM admin LIMIT 1;" 2>/dev/null)
            if [ "$CURRENT_ADMIN_ID" = "$TELEGRAM_CHAT_ID" ]; then
                echo -e "\033[32m? Admin ID verified: $CURRENT_ADMIN_ID\033[0m"
            else
                echo -e "\033[33m? Admin ID in database: $CURRENT_ADMIN_ID (expected: $TELEGRAM_CHAT_ID)\033[0m"
                # If not correct, update it directly in the database
                echo -e "\033[33mUpdating admin ID directly in database...\033[0m"
                mysql -u "$DB_USER" -p"$DB_PASS" -D "$DB_NAME" -e "UPDATE admin SET id_admin = '$TELEGRAM_CHAT_ID' WHERE id_admin = '$CURRENT_ADMIN_ID';"
                echo -e "\033[32mAdmin ID updated to $TELEGRAM_CHAT_ID\033[0m"
            fi
        fi
        
        if [ -f "$BACKUP_BEFORE_IMPORT" ]; then
            echo -e "\033[33mPre-import backup saved to: $BACKUP_BEFORE_IMPORT\033[0m"
        fi
        
        # Clean up temp file if created
        [ -n "$TEMP_SQL_FILE" ] && [ -f "$TEMP_SQL_FILE" ] && rm -f "$TEMP_SQL_FILE"
        
    else
        echo -e "\033[31m[ERROR] Failed to import database from backup file.\033[0m"
        echo -e "\033[33mError details saved to /tmp/import_error.log\033[0m"
        
        # Clean up temp file if created
        [ -n "$TEMP_SQL_FILE" ] && [ -f "$TEMP_SQL_FILE" ] && rm -f "$TEMP_SQL_FILE"
        
        # Offer to restore from backup
        if [ -f "$BACKUP_BEFORE_IMPORT" ]; then
            echo -ne "\033[36mRestore original database from backup? (yes/no): \033[0m"
            read RESTORE_DB
            if [[ "$RESTORE_DB" == "yes" ]]; then
                echo -e "\033[33mRestoring original database...\033[0m"
                mysql -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" < "$BACKUP_BEFORE_IMPORT"
                echo -e "\033[32mDatabase restored from backup.\033[0m"
            fi
        fi
        return 1
    fi
}


# Function for automated backup
function auto_backup() {
    echo -e "\033[36mConfigure Automated Backup\033[0m"

    # List all available bots in /var/www/html
    echo -e "\033[36mAvailable Bots:\033[0m"
    BOT_DIRS=$(ls -d /var/www/html/*/ 2>/dev/null | xargs -n 1 basename)

    if [ -z "$BOT_DIRS" ]; then
        echo -e "\033[31mNo bots found in /var/www/html.\033[0m"
        return 1
    fi

    echo "$BOT_DIRS" | nl -w 2 -s ") "

    # Prompt user to select a bot
    echo -ne "\033[36mEnter the bot name: \033[0m"
    read SELECTED_BOT

    # Validate selected bot
    if [[ ! "$BOT_DIRS" =~ (^|[[:space:]])$SELECTED_BOT($|[[:space:]]) ]]; then
        echo -e "\033[31mInvalid bot name. Please select from the list above.\033[0m"
        return 1
    fi

    # Set config path for selected bot
    BOT_DIR="/var/www/html/$SELECTED_BOT"
    CONFIG_FILE="$BOT_DIR/config.php"
    
    if [ ! -f "$CONFIG_FILE" ]; then
        echo -e "\033[31m[ERROR] config.php not found at $CONFIG_FILE\033[0m"
        return 1
    fi

    # Extract credentials from selected bot
    echo -e "\033[33mExtracting credentials from $SELECTED_BOT...\033[0m"
    DB_USER=$(grep '^\$usernamedb' "$CONFIG_FILE" | awk -F"'" '{print $2}')
    DB_PASS=$(grep '^\$passworddb' "$CONFIG_FILE" | awk -F"'" '{print $2}')
    DB_NAME=$(grep '^\$dbname' "$CONFIG_FILE" | awk -F"'" '{print $2}')
    TELEGRAM_TOKEN=$(grep '^\$APIKEY' "$CONFIG_FILE" | awk -F"'" '{print $2}')
    TELEGRAM_CHAT_ID=$(grep '^\$adminnumber' "$CONFIG_FILE" | awk -F"'" '{print $2}')

    if [ -z "$DB_USER" ] || [ -z "$DB_PASS" ] || [ -z "$DB_NAME" ] || [ -z "$TELEGRAM_TOKEN" ] || [ -z "$TELEGRAM_CHAT_ID" ]; then
        echo -e "\033[31m[ERROR] Failed to extract required credentials from $CONFIG_FILE.\033[0m"
        return 1
    fi

    echo -e "\033[32mCredentials extracted successfully for $SELECTED_BOT\033[0m"
    echo -e "  Database: $DB_NAME"
    echo -e "  Username: $DB_USER"
    echo -e "  Chat ID: $TELEGRAM_CHAT_ID"

    # Determine backup script based on Marzban presence
    if check_marzban_installed; then
        echo -e "\033[41m[NOTICE]\033[0m \033[33mMarzban detected. Using Marzban-compatible backup.\033[0m"
        BACKUP_SCRIPT="/root/backup_${SELECTED_BOT}_marzban.sh"
        MYSQL_CONTAINER=$(docker ps -q --filter "name=mysql" --no-trunc)
        if [ -z "$MYSQL_CONTAINER" ]; then
            echo -e "\033[31m[ERROR]\033[0m No running MySQL container found for Marzban."
            return 1
        fi
        # Create Marzban backup script
        cat <<EOF > "$BACKUP_SCRIPT"
#!/bin/bash
BACKUP_FILE="/root/${DB_NAME}_\$(date +\"%Y%m%d_%H%M%S\").sql"
echo "Creating backup for $SELECTED_BOT (\$BACKUP_FILE)..." >> /var/log/backup_${SELECTED_BOT}.log
docker exec $MYSQL_CONTAINER mysqldump -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" > "\$BACKUP_FILE"
if [ \$? -eq 0 ]; then
    echo "Backup created successfully, sending to Telegram..." >> /var/log/backup_${SELECTED_BOT}.log
    curl -s -F document=@"\$BACKUP_FILE" "https://api.telegram.org/bot$TELEGRAM_TOKEN/sendDocument" -F chat_id="$TELEGRAM_CHAT_ID" -F caption="Backup for $SELECTED_BOT - \$DB_NAME - \$(date)" >> /var/log/backup_${SELECTED_BOT}.log 2>&1
    rm "\$BACKUP_FILE"
    echo "Backup process completed for $SELECTED_BOT" >> /var/log/backup_${SELECTED_BOT}.log
else
    echo "Failed to create backup for $SELECTED_BOT" >> /var/log/backup_${SELECTED_BOT}.log
    curl -s -F text="? Backup failed for $SELECTED_BOT" "https://api.telegram.org/bot$TELEGRAM_TOKEN/sendMessage" -F chat_id="$TELEGRAM_CHAT_ID" >> /var/log/backup_${SELECTED_BOT}.log 2>&1
fi
EOF
    else
        echo -e "\033[33mUsing standard backup.\033[0m"
        BACKUP_SCRIPT="/root/backup_${SELECTED_BOT}.sh"
        # Verify database existence
        if ! mysql -u "$DB_USER" -p"$DB_PASS" -e "USE $DB_NAME;" 2>/dev/null; then
            echo -e "\033[31m[ERROR]\033[0m Database $DB_NAME does not exist or credentials are incorrect."
            return 1
        fi
        # Create standard backup script
        cat <<EOF > "$BACKUP_SCRIPT"
#!/bin/bash
BACKUP_FILE="/root/${DB_NAME}_\$(date +\"%Y%m%d_%H%M%S\").sql"
echo "Creating backup for $SELECTED_BOT (\$BACKUP_FILE)..." >> /var/log/backup_${SELECTED_BOT}.log
mysqldump -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" > "\$BACKUP_FILE"
if [ \$? -eq 0 ]; then
    echo "Backup created successfully, sending to Telegram..." >> /var/log/backup_${SELECTED_BOT}.log
    curl -s -F document=@"\$BACKUP_FILE" "https://api.telegram.org/bot$TELEGRAM_TOKEN/sendDocument" -F chat_id="$TELEGRAM_CHAT_ID" -F caption="Backup for $SELECTED_BOT - \$DB_NAME - \$(date)" >> /var/log/backup_${SELECTED_BOT}.log 2>&1
    rm "\$BACKUP_FILE"
    echo "Backup process completed for $SELECTED_BOT" >> /var/log/backup_${SELECTED_BOT}.log
else
    echo "Failed to create backup for $SELECTED_BOT" >> /var/log/backup_${SELECTED_BOT}.log
    curl -s -F text="? Backup failed for $SELECTED_BOT" "https://api.telegram.org/bot$TELEGRAM_TOKEN/sendMessage" -F chat_id="$TELEGRAM_CHAT_ID" >> /var/log/backup_${SELECTED_BOT}.log 2>&1
fi
EOF
    fi

    # Make the script executable
    chmod +x "$BACKUP_SCRIPT"

    # Check current cron for this specific bot
    CURRENT_CRON=$(crontab -l 2>/dev/null | grep "$BACKUP_SCRIPT" | grep -v "^#")
    if [ -n "$CURRENT_CRON" ]; then
        SCHEDULE=$(translate_cron "$CURRENT_CRON")
        echo -e "\033[33mCurrent Backup Schedule for $SELECTED_BOT:\033[0m $SCHEDULE"
    else
        echo -e "\033[33mNo active backup schedule found for $SELECTED_BOT.\033[0m"
    fi

    # Show backup frequency options
    echo -e "\033[36mBackup Frequency for $SELECTED_BOT:\033[0m"
    echo -e "  1) Every Minute"
    echo -e "  2) Every Hour"
    echo -e "  3) Every Day"
    echo -e "  4) Every Week"
    echo -e "  5) Disable Backup"
    echo -e "  6) Back to Menu"
    echo ""
    read -p "Select an option [1-6]: " backup_option

    # Function to update cron
    update_cron() {
        local cron_line="$1"
        if [ -n "$CURRENT_CRON" ]; then
            crontab -l 2>/dev/null | grep -v "$BACKUP_SCRIPT" | crontab - && {
                echo -e "\033[92mRemoved previous backup schedule for $SELECTED_BOT.\033[0m"
            } || {
                echo -e "\033[31mFailed to remove existing cron for $SELECTED_BOT.\033[0m"
            }
        fi
        if [ -n "$cron_line" ]; then
            (crontab -l 2>/dev/null; echo "$cron_line") | crontab - && {
                echo -e "\033[92mBackup scheduled for $SELECTED_BOT: $(translate_cron "$cron_line")\033[0m"
                # Test backup immediately
                echo -e "\033[33mTesting backup for $SELECTED_BOT...\033[0m"
                bash "$BACKUP_SCRIPT" &>/dev/null &
            } || {
                echo -e "\033[31mFailed to schedule backup for $SELECTED_BOT.\033[0m"
            }
        fi
    }

    # Process user choice
    case $backup_option in
        1) update_cron "* * * * * bash $BACKUP_SCRIPT" ;;
        2) update_cron "0 * * * * bash $BACKUP_SCRIPT" ;;
        3) update_cron "0 0 * * * bash $BACKUP_SCRIPT" ;;
        4) update_cron "0 0 * * 0 bash $BACKUP_SCRIPT" ;;
        5)
            if [ -n "$CURRENT_CRON" ]; then
                crontab -l 2>/dev/null | grep -v "$BACKUP_SCRIPT" | crontab - && {
                    echo -e "\033[92mAutomated backup disabled for $SELECTED_BOT.\033[0m"
                } || {
                    echo -e "\033[31mFailed to disable backup for $SELECTED_BOT.\033[0m"
                }
            else
                echo -e "\033[93mNo backup schedule to disable for $SELECTED_BOT.\033[0m"
            fi
            ;;
        6) show_menu ;;
        *)
            echo -e "\033[31mInvalid option. Please try again.\033[0m"
            auto_backup
            ;;
    esac
}

# Function to renew SSL certificates
function renew_ssl() {
    echo -e "\033[33mStarting SSL renewal process...\033[0m"

    if ! command -v certbot &>/dev/null; then
        echo -e "\033[31m[ERROR]\033[0m Certbot is not installed. Please install Certbot to proceed."
        return 1
    fi

    # Stop Apache to free port 80
    echo -e "\033[33mStopping Apache...\033[0m"
    sudo systemctl stop apache2 || {
        echo -e "\033[31m[ERROR]\033[0m Failed to stop Apache. Exiting..."
        return 1
    }

    # Renew SSL certificates
    if sudo certbot renew; then
        echo -e "\033[32mSSL certificates successfully renewed.\033[0m"
    else
        echo -e "\033[31m[ERROR]\033[0m SSL renewal failed. Please check Certbot logs for more details."
        # Restart Apache even if renewal failed
        sudo systemctl start apache2
        return 1
    fi

    # Restart Apache
    echo -e "\033[33mRestarting Apache...\033[0m"
    sudo systemctl restart apache2 || {
        echo -e "\033[31m[WARNING]\033[0m Failed to restart Apache. Please check manually."
    }
}



function change_domain() {
    echo -e "\033[36mAvailable Bots:\033[0m"
    BOT_DIRS=$(ls -d /var/www/html/*/ 2>/dev/null | grep -v "/var/www/html/mirzabotconfig" | xargs -n 1 basename)

    if [ -z "$BOT_DIRS" ]; then
        echo -e "\033[31mNo additional bots found in /var/www/html.\033[0m"
        return 1
    fi

    echo "$BOT_DIRS" | nl -w 2 -s ") "

    echo -ne "\033[36mEnter the bot name: \033[0m"
    read SELECTED_BOT

    if [[ ! "$BOT_DIRS" =~ (^|[[:space:]])$SELECTED_BOT($|[[:space:]]) ]]; then
        echo -e "\033[31mInvalid bot name. Please select from the list above.\033[0m"
        return 1
    fi

    CONFIG_FILE="/var/www/html/$SELECTED_BOT/config.php"
    if [ ! -f "$CONFIG_FILE" ]; then
        echo -e "\033[31m[ERROR] config.php not found at $CONFIG_FILE\033[0m"
        return 1
    fi

    CURRENT_DOMAIN_PATH=$(grep '^\$domainhosts' "$CONFIG_FILE" | awk -F"'" '{print $2}')
    CURRENT_DOMAIN=$(echo "$CURRENT_DOMAIN_PATH" | cut -d'/' -f1)
    CURRENT_PATH=$(echo "$CURRENT_DOMAIN_PATH" | cut -d'/' -f2-)

    echo -e "\033[33mCurrent domain for $SELECTED_BOT: $CURRENT_DOMAIN\033[0m"
    echo -e "\033[33mCurrent path: $CURRENT_PATH\033[0m"

    local new_domain
    while [[ ! "$new_domain" =~ ^[a-zA-Z0-9.-]+$ ]]; do
        read -p "Enter new domain for $SELECTED_BOT: " new_domain
        [[ ! "$new_domain" =~ ^[a-zA-Z0-9.-]+$ ]] && echo -e "\033[31mInvalid domain format\033[0m"
    done

    # Detect Apache configuration file for this domain or bot
    SITE_CONF=$(grep -ril "$CURRENT_DOMAIN" /etc/apache2/sites-available/ | head -n 1)
    if [ -z "$SITE_CONF" ]; then
        SITE_CONF="/etc/apache2/sites-available/${new_domain}.conf"
        echo -e "\033[33mNo existing site config found. Creating new one at $SITE_CONF\033[0m"
        sudo bash -c "cat > $SITE_CONF" <<EOF
<VirtualHost *:80>
    ServerName $new_domain
    DocumentRoot /var/www/html/$SELECTED_BOT
    <Directory /var/www/html/$SELECTED_BOT>
        AllowOverride All
        Require all granted
    </Directory>
    ErrorLog \${APACHE_LOG_DIR}/${new_domain}_error.log
    CustomLog \${APACHE_LOG_DIR}/${new_domain}_access.log combined
</VirtualHost>
EOF
    else
        echo -e "\033[32mFound existing Apache config: $SITE_CONF\033[0m"
        sudo sed -i "s|ServerName .*|ServerName $new_domain|" "$SITE_CONF"
        sudo sed -i "s|DocumentRoot .*|DocumentRoot /var/www/html/$SELECTED_BOT|" "$SITE_CONF"
    fi

    # Enable site and reload Apache
    sudo a2ensite "$(basename "$SITE_CONF")" &>/dev/null
    sudo systemctl reload apache2

    echo -e "\033[33mObtaining SSL for $new_domain...\033[0m"
    if ! sudo certbot --apache --redirect --agree-tos --non-interactive --preferred-challenges http \
        -m "admin@$new_domain" -d "$new_domain"; then
        echo -e "\033[31m[ERROR] SSL configuration failed for $new_domain!\033[0m"
        return 1
    fi

    echo -e "\033[32mSSL successfully configured for $new_domain!\033[0m"

    # Update bot configuration
    BACKUP_FILE="$CONFIG_FILE.$(date +%s).bak"
    sudo cp "$CONFIG_FILE" "$BACKUP_FILE"
    echo -e "\033[32mConfig backup created: $BACKUP_FILE\033[0m"

    NEW_DOMAIN_PATH="${new_domain}"
    sudo sed -i "s|\$domainhosts = '.*';|\$domainhosts = '${NEW_DOMAIN_PATH}';|" "$CONFIG_FILE"
    echo -e "\033[32mDomain updated to: ${NEW_DOMAIN_PATH}\033[0m"

    NEW_SECRET=$(openssl rand -base64 12 | tr -dc 'a-zA-Z0-9')
    sudo sed -i "s/\$secrettoken = '.*';/\$secrettoken = '${NEW_SECRET}';/" "$CONFIG_FILE"
    echo -e "\033[32mSecret token updated\033[0m"

    BOT_TOKEN=$(awk -F"'" '/\$APIKEY/{print $2}' "$CONFIG_FILE")
    if [ -n "$BOT_TOKEN" ]; then
        echo -e "\033[33mUpdating Telegram webhook...\033[0m"
        WEBHOOK_URL="https://${new_domain}/${SELECTED_BOT}/index.php"
        curl -s -o /dev/null -F "url=$WEBHOOK_URL" \
             -F "secret_token=${NEW_SECRET}" \
             "https://api.telegram.org/bot${BOT_TOKEN}/setWebhook"

        if [ $? -eq 0 ]; then
            echo -e "\033[32mWebhook updated successfully: $WEBHOOK_URL\033[0m"
        else
            echo -e "\033[33m[WARNING] Webhook update failed\033[0m"
        fi
    else
        echo -e "\033[33m[WARNING] Bot token not found, skipping webhook update\033[0m"
    fi

    # Verify SSL and domain
    echo -e "\033[33mVerifying new domain and SSL...\033[0m"
    if curl -sI "https://${new_domain}" | grep -q "200 OK"; then
        echo -e "\033[32mDomain successfully migrated to ${new_domain}\033[0m"
    else
        echo -e "\033[33mVerification failed — please check Apache or DNS.\033[0m"
    fi

    echo -e "\033[36mMigration Summary:\033[0m"
    echo -e "  Bot: $SELECTED_BOT"
    echo -e "  Old Domain: $CURRENT_DOMAIN_PATH"
    echo -e "  New Domain: $NEW_DOMAIN_PATH"
    echo -e "  Apache Config: $SITE_CONF"
    echo -e "  Config Backup: $BACKUP_FILE"
    if [ -n "$WEBHOOK_URL" ]; then
        echo -e "  Webhook: $WEBHOOK_URL"
    fi
}

# Added Function for Installing Additional Bot
function install_additional_bot() {
    clear
    echo -e "\033[33mStarting Additional Bot Installation...\033[0m"

    # Check for root credentials file
    ROOT_CREDENTIALS_FILE="/root/confmirza/dbrootmirza.txt"
    if [[ ! -f "$ROOT_CREDENTIALS_FILE" ]]; then
        echo -e "\033[31mError: Root credentials file not found at $ROOT_CREDENTIALS_FILE.\033[0m"
        echo -ne "\033[36mPlease enter the root MySQL password: \033[0m"
        read -s ROOT_PASS
        echo
        ROOT_USER="root"
    else
        ROOT_USER=$(grep '\$user =' "$ROOT_CREDENTIALS_FILE" | awk -F"'" '{print $2}')
        ROOT_PASS=$(grep '\$pass =' "$ROOT_CREDENTIALS_FILE" | awk -F"'" '{print $2}')
        if [[ -z "$ROOT_USER" || -z "$ROOT_PASS" ]]; then
            echo -e "\033[31mError: Could not extract root credentials from file.\033[0m"
            return 1
        fi
    fi
    
    # Request Bot Name
    while true; do
        echo -ne "\033[36mEnter the bot name: \033[0m"
        read BOT_NAME
        if [[ "$BOT_NAME" =~ ^[a-zA-Z0-9_-]+$ && ! -d "/var/www/html/$BOT_NAME" ]]; then
            break
        else
            echo -e "\033[31mInvalid or duplicate bot name. Please try again.\033[0m"
        fi
    done


    # Request Domain Name
    while true; do
        echo -ne "\033[36mEnter the domain for the additional bot: \033[0m"
        read DOMAIN_NAME
        if [[ "$DOMAIN_NAME" =~ ^[a-zA-Z0-9.-]+$ ]]; then
            break
        else
            echo -e "\033[31mInvalid domain format. Please try again.\033[0m"
        fi
    done

    # Stop Apache to free port 80
    echo -e "\033[33mStopping Apache to free port 80...\033[0m"
    sudo systemctl stop apache2

    # Obtain SSL Certificate
    echo -e "\033[33mObtaining SSL certificate...\033[0m"
    sudo certbot certonly --standalone --agree-tos --preferred-challenges http -d "$DOMAIN_NAME" || {
        echo -e "\033[31mError obtaining SSL certificate.\033[0m"
        return 1
    }

    # Restart Apache
    echo -e "\033[33mRestarting Apache...\033[0m"
    sudo systemctl start apache2

    # Configure Apache for new domain
    APACHE_CONFIG="/etc/apache2/sites-available/$DOMAIN_NAME.conf"
    if [[ -f "$APACHE_CONFIG" ]]; then
        echo -e "\033[31mApache configuration for this domain already exists.\033[0m"
        return 1
    fi

    echo -e "\033[33mConfiguring Apache for domain...\033[0m"
    sudo bash -c "cat > $APACHE_CONFIG <<EOF
<VirtualHost *:80>
    ServerName $DOMAIN_NAME
    Redirect permanent / https://$DOMAIN_NAME/
</VirtualHost>

<VirtualHost *:443>
    ServerName $DOMAIN_NAME
    DocumentRoot /var/www/html/$BOT_NAME
    
    	# Aliases for selected bot
	Alias /$BOT_NAME "/var/www/html/$BOT_NAME"
	Alias /$BOT_NAME/app "/var/www/html/$BOT_NAME/app"
	Alias /$BOT_NAME/panel "/var/www/html/$BOT_NAME/panel"

	# Directory permissions for main bot
	<Directory "/var/www/html/$BOT_NAME">
		Options Indexes FollowSymLinks
		AllowOverride All
		Require all granted
	</Directory>

	# Directory permissions for app
	<Directory "/var/www/html/$BOT_NAME/app">
		Options Indexes FollowSymLinks
		AllowOverride All
		Require all granted
	</Directory>

	# Directory permissions for panel
	<Directory "/var/www/html/$BOT_NAME/panel">
		Options Indexes FollowSymLinks
		AllowOverride All
		Require all granted
	</Directory>

    SSLEngine on
    SSLCertificateFile /etc/letsencrypt/live/$DOMAIN_NAME/fullchain.pem
    SSLCertificateKeyFile /etc/letsencrypt/live/$DOMAIN_NAME/privkey.pem
</VirtualHost>
EOF"

    sudo mkdir -p "/var/www/html/$BOT_NAME"
    sudo a2ensite "$DOMAIN_NAME.conf"
    sudo systemctl reload apache2

    
    # Clone a Fresh Copy of the Bot's Source Code
    BOT_DIR="/var/www/html/$BOT_NAME"
    echo -e "\033[33mCloning bot's source code...\033[0m"
    git clone https://github.com/Mmdd93/mirza_pro.git "$BOT_DIR" || {
        echo -e "\033[31mError: Failed to clone the repository.\033[0m"
        return 1
    }

    # Request Bot Token
    while true; do
        echo -ne "\033[36mEnter the bot token: \033[0m"
        read BOT_TOKEN
        if [[ "$BOT_TOKEN" =~ ^[0-9]{8,10}:[a-zA-Z0-9_-]{35}$ ]]; then
            break
        else
            echo -e "\033[31mInvalid bot token format. Please try again.\033[0m"
        fi
    done

    # Request Chat ID
    while true; do
        echo -ne "\033[36mEnter the chat ID: \033[0m"
        read CHAT_ID
        if [[ "$CHAT_ID" =~ ^-?[0-9]+$ ]]; then
            break
        else
            echo -e "\033[31mInvalid chat ID format. Please try again.\033[0m"
        fi
    done

    # Configure Database
    DB_NAME="mirzabot_$BOT_NAME"
    DB_USERNAME="$DB_NAME"
    DEFAULT_PASSWORD=$(openssl rand -base64 10 | tr -dc 'a-zA-Z0-9' | cut -c1-8)
    echo -ne "\033[36mEnter the database password (default: $DEFAULT_PASSWORD): \033[0m"
    read DB_PASSWORD
    DB_PASSWORD=${DB_PASSWORD:-$DEFAULT_PASSWORD}

    echo -e "\033[33mCreating database and user...\033[0m"
    sudo mysql -u "$ROOT_USER" -p"$ROOT_PASS" -e "CREATE DATABASE $DB_NAME;" || {
        echo -e "\033[31mError: Failed to create database.\033[0m"
        return 1
    }
    sudo mysql -u "$ROOT_USER" -p"$ROOT_PASS" -e "CREATE USER '$DB_USERNAME'@'localhost' IDENTIFIED BY '$DB_PASSWORD';" || {
        echo -e "\033[31mError: Failed to create database user.\033[0m"
        return 1
    }
    sudo mysql -u "$ROOT_USER" -p"$ROOT_PASS" -e "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USERNAME'@'localhost';" || {
        echo -e "\033[31mError: Failed to grant privileges to user.\033[0m"
        return 1
    }
    sudo mysql -u "$ROOT_USER" -p"$ROOT_PASS" -e "FLUSH PRIVILEGES;"

    # Configure the Bot
    CONFIG_FILE="$BOT_DIR/config.php"
    echo -e "\033[33mSaving bot configuration...\033[0m"
    cat <<EOF > "$CONFIG_FILE"
<?php
\$APIKEY = '$BOT_TOKEN';
\$usernamedb = '$DB_USERNAME';
\$passworddb = '$DB_PASSWORD';
\$dbname = '$DB_NAME';
\$domainhosts = '$DOMAIN_NAME';
\$adminnumber = '$CHAT_ID';
\$usernamebot = '$BOT_NAME';
\$connect = mysqli_connect('localhost', \$usernamedb, \$passworddb, \$dbname);
if (\$connect->connect_error) {
    die('Database connection failed: ' . \$connect->connect_error);
}
mysqli_set_charset(\$connect, 'utf8mb4');
\$options = [
    PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
    PDO::ATTR_EMULATE_PREPARES   => false,
];
\$dsn = "mysql:host=localhost;dbname=\$dbname;charset=utf8mb4";
try {
     \$pdo = new PDO(\$dsn, \$usernamedb, \$passworddb, \$options);
} catch (\PDOException \$e) {
     throw new \PDOException(\$e->getMessage(), (int)\$e->getCode());
}
?>
EOF

    sleep 1

    sudo chown -R www-data:www-data "$BOT_DIR"
    sudo chmod -R 755 "$BOT_DIR"

    # Set Webhook
    echo -e "\033[33mSetting webhook for bot...\033[0m"
    curl -F "url=https://$DOMAIN_NAME/$BOT_NAME/index.php" "https://api.telegram.org/bot$BOT_TOKEN/setWebhook" || {
        echo -e "\033[31mError: Failed to set webhook for bot.\033[0m"
        return 1
    }

    # Send Installation Confirmation
    MESSAGE="? The bot is installed! for start bot send comment /start"
    curl -s -X POST "https://api.telegram.org/bot${BOT_TOKEN}/sendMessage" -d chat_id="${CHAT_ID}" -d text="$MESSAGE" || {
        echo -e "\033[31mError: Failed to send message to Telegram.\033[0m"
        return 1
    }

 #################################         
            
   echo -e "\033[36mDatabase Import Tool\033[0m"

   

    # Set config path for selected bot
    BOT_DIR="/var/www/html/$BOT_NAME"
    CONFIG_FILE="$BOT_DIR/config.php"
    
    if [ ! -f "$CONFIG_FILE" ]; then
        echo -e "\033[31m[ERROR] config.php not found at $CONFIG_FILE\033[0m"
        return 1
    fi

    # Extract credentials from selected bot
    echo -e "\033[33mExtracting credentials from $BOT_NAME...\033[0m"
    DB_USER=$(grep '^\$usernamedb' "$CONFIG_FILE" | awk -F"'" '{print $2}')
    DB_PASS=$(grep '^\$passworddb' "$CONFIG_FILE" | awk -F"'" '{print $2}')
    DB_NAME=$(grep '^\$dbname' "$CONFIG_FILE" | awk -F"'" '{print $2}')
    TELEGRAM_TOKEN=$(grep '^\$APIKEY' "$CONFIG_FILE" | awk -F"'" '{print $2}')
    TELEGRAM_CHAT_ID=$(grep '^\$adminnumber' "$CONFIG_FILE" | awk -F"'" '{print $2}')

    if [ -z "$DB_USER" ] || [ -z "$DB_PASS" ] || [ -z "$DB_NAME" ]; then
        echo -e "\033[31m[ERROR] Failed to extract required database credentials from $CONFIG_FILE.\033[0m"
        return 1
    fi

    echo -e "\033[32mCredentials extracted successfully for $BOT_NAME\033[0m"
    echo -e "  Database: $DB_NAME"
    echo -e "  Username: $DB_USER"

    # Check if Marzban is installed
    if check_marzban_installed; then
        echo -e "\033[31m[ERROR]\033[0m Importing database is not supported when Marzban is installed due to database being managed by Docker."
        return 1
    fi

    echo -e "\033[33mVerifying database existence...\033[0m"

    if ! mysql -u "$DB_USER" -p"$DB_PASS" -e "USE $DB_NAME;" 2>/dev/null; then
        echo -e "\033[31m[ERROR]\033[0m Database $DB_NAME does not exist or credentials are incorrect."
        return 1
    fi

    # Automatically use mirzabot.sql in the bot directory
    BACKUP_FILE="$BOT_DIR/mirzabot.sql"
    
    if [ ! -f "$BACKUP_FILE" ]; then
        echo -e "\033[31m[ERROR] mirzabot.sql not found in $BOT_DIR\033[0m"
        echo -e "\033[33mAvailable files in $BOT_DIR:\033[0m"
        ls -la "$BOT_DIR" | head -10
        return 1
    fi

    echo -e "\033[33mUsing SQL file: $BACKUP_FILE\033[0m"
    echo -e "\033[33mFile size: $(du -h "$BACKUP_FILE" | cut -f1)\033[0m"

    # Simple approach: Drop all tables and import fresh
    echo -e "\033[33mDropping all existing tables...\033[0m"
    
    # Get list of tables and drop them
    TABLES=$(mysql -u "$DB_USER" -p"$DB_PASS" -D "$DB_NAME" -s -N -e "SHOW TABLES;")
    if [ -n "$TABLES" ]; then
        mysql -u "$DB_USER" -p"$DB_PASS" -D "$DB_NAME" -e "SET FOREIGN_KEY_CHECKS = 0;"
        for table in $TABLES; do
            mysql -u "$DB_USER" -p"$DB_PASS" -D "$DB_NAME" -e "DROP TABLE IF EXISTS \`$table\`;"
        done
        mysql -u "$DB_USER" -p"$DB_PASS" -D "$DB_NAME" -e "SET FOREIGN_KEY_CHECKS = 1;"
        echo -e "\033[32mAll tables dropped successfully.\033[0m"
    else
        echo -e "\033[32mDatabase was already empty.\033[0m"
    fi

    # Perform the import
    echo -e "\033[33mImporting database from $BACKUP_FILE...\033[0m"
    
    START_TIME=$(date +%s)
    
    if mysql -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" < "$BACKUP_FILE" 2>/tmp/import_error.log; then
        END_TIME=$(date +%s)
        DURATION=$((END_TIME - START_TIME))
        
        echo -e "\033[32mDatabase successfully imported from $BACKUP_FILE.\033[0m"
        echo -e "\033[33mImport completed in ${DURATION} seconds.\033[0m"
        
        # Verify import
        echo -e "\033[33mVerifying import...\033[0m"
        IMPORTED_TABLES=$(mysql -u "$DB_USER" -p"$DB_PASS" -D "$DB_NAME" -s -N -e "SHOW TABLES;" 2>/dev/null | wc -l)
        echo -e "\033[32mDatabase now contains $IMPORTED_TABLES tables.\033[0m"
        
        # Update admin ID if needed
        if [ -n "$TELEGRAM_CHAT_ID" ]; then
            echo -e "\033[33mUpdating admin ID to $TELEGRAM_CHAT_ID...\033[0m"
            mysql -u "$DB_USER" -p"$DB_PASS" -D "$DB_NAME" -e "UPDATE admin SET id_admin = '$TELEGRAM_CHAT_ID' WHERE id_admin != '$TELEGRAM_CHAT_ID';" 2>/dev/null
            echo -e "\033[32mAdmin ID updated.\033[0m"
        fi
        
    else
        echo -e "\033[31m[ERROR] Failed to import database from backup file.\033[0m"
        echo -e "\033[33mError details saved to /tmp/import_error.log\033[0m"
        return 1
    fi
    
##############################################  

    # Output Bot Information
    echo -e "\033[32mBot installed successfully!\033[0m"
    echo -e "\033[102mDomain Bot: https://$DOMAIN_NAME\033[0m"
    echo -e "\033[104mDatabase address: https://$DOMAIN_NAME/phpmyadmin\033[0m"
    echo -e "\033[33mDatabase name: \033[36m$DB_NAME\033[0m"
    echo -e "\033[33mDatabase username: \033[36m$DB_USERNAME\033[0m"
    echo -e "\033[33mDatabase password: \033[36m$DB_PASSWORD\033[0m"
}



# Function to Remove Additional Bot
function remove_additional_bot() {
    clear
    echo -e "\033[36mAvailable Bots:\033[0m"

    # List directories in /var/www/html excluding mirzabotconfig
    BOT_DIRS=$(ls -d /var/www/html/*/ 2>/dev/null | grep -v "/var/www/html/mirzabotconfig" | xargs -n 1 basename)

    if [ -z "$BOT_DIRS" ]; then
        echo -e "\033[31mNo additional bots found in /var/www/html.\033[0m"
        return 1
    fi

    echo "$BOT_DIRS" | nl -w 2 -s ") "

    # Prompt user to select a bot
    echo -ne "\033[36mEnter the bot name: \033[0m"
    read SELECTED_BOT

    if [[ ! "$BOT_DIRS" =~ (^|[[:space:]])$SELECTED_BOT($|[[:space:]]) ]]; then
        echo -e "\033[31mInvalid bot name.\033[0m"
        return 1
    fi

    BOT_PATH="/var/www/html/$SELECTED_BOT"
    CONFIG_PATH="$BOT_PATH/config.php"

    if [ ! -f "$CONFIG_PATH" ]; then
        echo -e "\033[31mconfig.php not found for $SELECTED_BOT.\033[0m"
        return 1
    fi

    # Confirm removal
    echo -ne "\033[36mAre you sure you want to remove $SELECTED_BOT? (yes/no): \033[0m"
    read CONFIRM_REMOVE
    if [[ "$CONFIRM_REMOVE" != "yes" ]]; then
        echo -e "\033[33mAborted.\033[0m"
        return 1
    fi

    # Confirm database backup
    echo -ne "\033[36mHave you backed up the database? (yes/no): \033[0m"
    read BACKUP_CONFIRM
    if [[ "$BACKUP_CONFIRM" != "yes" ]]; then
        echo -e "\033[33mAborted. Please backup the database first.\033[0m"
        return 1
    fi

    # Extract DB credentials and domain from config.php
    DB_NAME=$(grep '^\$dbname' "$CONFIG_PATH" | awk -F"'" '{print $2}')
    DB_USER=$(grep '^\$usernamedb' "$CONFIG_PATH" | awk -F"'" '{print $2}')
    DB_PASS=$(grep '^\$passworddb' "$CONFIG_PATH" | awk -F"'" '{print $2}')
    DOMAIN_NAME=$(grep '^\$domainhosts' "$CONFIG_PATH" | awk -F"'" '{print $2}' | cut -d"/" -f1)

    if [ -z "$DB_NAME" ] || [ -z "$DB_USER" ]; then
        echo -e "\033[31m[ERROR]\033[0m Failed to extract database credentials from $CONFIG_PATH."
        return 1
    fi

    # Get MySQL root credentials
    ROOT_USER="root"
    ROOT_PASS=""
    ROOT_CREDENTIALS_FILE="/root/confmirza/dbrootmirza.txt"
    if [ -f "$ROOT_CREDENTIALS_FILE" ]; then
        ROOT_USER=$(grep '\$user =' "$ROOT_CREDENTIALS_FILE" | awk -F"'" '{print $2}')
        ROOT_PASS=$(grep '\$pass =' "$ROOT_CREDENTIALS_FILE" | awk -F"'" '{print $2}')
    else
        echo -ne "\033[36mEnter MySQL root username (default: root): \033[0m"
        read INPUT_USER
        ROOT_USER=${INPUT_USER:-root}
        echo -ne "\033[36mEnter MySQL root password (leave empty if none): \033[0m"
        read -s ROOT_PASS
        echo
    fi

    # Build MySQL command
    MYSQL_CMD="mysql -u $ROOT_USER"
    if [ -n "$ROOT_PASS" ]; then
        MYSQL_CMD="$MYSQL_CMD -p$ROOT_PASS"
    fi

    # Remove database
    echo -e "\033[33mRemoving database $DB_NAME...\033[0m"
    $MYSQL_CMD -e "DROP DATABASE IF EXISTS \`$DB_NAME\`;" 2>/tmp/remove_bot_db_error.log
    if [ $? -eq 0 ]; then
        echo -e "\033[32mDatabase $DB_NAME removed successfully.\033[0m"
    else
        echo -e "\033[31mFailed to remove database $DB_NAME. See /tmp/remove_bot_db_error.log\033[0m"
    fi

    # Remove database user
    echo -e "\033[33mRemoving database user $DB_USER...\033[0m"
    $MYSQL_CMD -e "DROP USER IF EXISTS '$DB_USER'@'localhost';" 2>/tmp/remove_bot_user_error.log
    if [ $? -eq 0 ]; then
        echo -e "\033[32mUser $DB_USER removed successfully.\033[0m"
    else
        echo -e "\033[31mFailed to remove user $DB_USER. See /tmp/remove_bot_user_error.log\033[0m"
    fi

    # Remove bot directory
    echo -e "\033[33mRemoving bot directory $BOT_PATH...\033[0m"
    if rm -rf "$BOT_PATH"; then
        echo -e "\033[32mBot directory removed successfully.\033[0m"
    else
        echo -e "\033[31mFailed to remove bot directory.\033[0m"
    fi

    # Remove Apache configuration
    if [ -n "$DOMAIN_NAME" ]; then
        APACHE_CONF="/etc/apache2/sites-available/$DOMAIN_NAME.conf"
        if [ -f "$APACHE_CONF" ]; then
            echo -e "\033[33mRemoving Apache configuration for $DOMAIN_NAME...\033[0m"
            sudo a2dissite "$DOMAIN_NAME.conf" >/dev/null 2>&1
            sudo rm -f "$APACHE_CONF" "/etc/apache2/sites-enabled/$DOMAIN_NAME.conf"
            sudo systemctl reload apache2
            echo -e "\033[32mApache configuration removed successfully.\033[0m"
        else
            echo -e "\033[33mApache configuration for $DOMAIN_NAME not found. Skipping.\033[0m"
        fi
    fi

    echo -e "\033[32m$SELECTED_BOT has been successfully removed.\033[0m"
}




show_menu
