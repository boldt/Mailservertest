#/bib/bash

# Define domain

export DOMAIN=$1
echo "Domain: ${DOMAIN}"

echo "#########################################################"
echo "### Resolve MX IP for domain ${DOMAIN}"
echo "#########################################################"

export IP_A=`dig          +short $(dig          ${DOMAIN} MX +short | awk '{ print $2 }') A`
echo "IP: ${IP_A}"
export IP_B=`dig @1.1.1.1 +short $(dig @1.1.1.1 ${DOMAIN} MX +short | awk '{ print $2 }') A`
echo "IP: ${IP_B}"
export IP_C=`dig @8.8.8.8 +short $(dig @8.8.8.8 ${DOMAIN} MX +short | awk '{ print $2 }') A`
echo "IP: ${IP_C}"

echo "#########################################################"
echo "### Resolve MX for domain ${DOMAIN}"
echo "#########################################################"

dig          ${DOMAIN} MX +short | awk '{ print $2 }'
dig @1.1.1.1 ${DOMAIN} MX +short | awk '{ print $2 }'
dig @8.8.8.8 ${DOMAIN} MX +short | awk '{ print $2 }'

echo "#########################################################"
echo "### Test SPF for domain ${DOMAIN}"
echo "#########################################################"

dig          +short ${DOMAIN} IN TXT | grep spf1
dig @1.1.1.1 +short ${DOMAIN} IN TXT | grep spf1
dig @8.8.8.8 +short ${DOMAIN} IN TXT | grep spf1

echo "#########################################################"
echo "### Test DKIM for domain ${DOMAIN}"
echo "#########################################################"

dig          +short dkim._domainkey.${DOMAIN} IN TXT | grep DKIM1
dig @1.1.1.1 +short dkim._domainkey.${DOMAIN} IN TXT | grep DKIM1
dig @8.8.8.8 +short dkim._domainkey.${DOMAIN} IN TXT | grep DKIM1

echo "#########################################################"
echo "### Test DMARC for domain ${DOMAIN}"
echo "#########################################################"

dig          +short _dmarc.${DOMAIN} IN TXT | grep DMARC1
dig @1.1.1.1 +short _dmarc.${DOMAIN} IN TXT | grep DMARC1
dig @8.8.8.8 +short _dmarc.${DOMAIN} IN TXT | grep DMARC1

echo "#########################################################"
echo "### Test PTR for MX IP"
echo "#########################################################"

dig +short -x ${IP_A}
dig @1.1.1.1 +short -x ${IP_B}
dig @8.8.8.8 +short -x ${IP_C}

echo "#########################################################"

