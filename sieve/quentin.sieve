# Sieve mail filter for quentin@minster.io


# Extensions
require ["fileinto"];


# rule:[mine]
if address :domain :contains ["To","Cc","Bcc"] "minster.io" {
    # Keep my messages in the inbox, don't process them further
    stop;
}

# rule:[LKML]
if header :contains ["List-ID"] "linux-kernel.vger.kernel.org" {
    fileinto "Kernel";
    stop;
}

# rule:[Kernelnewbies]
if header :contains ["List-Id"] "kernelnewbies.kernelnewbies.org" {
    fileinto "Kernel.kernelnewbies";
    stop;
}

# rule:[kernel-janitors]
if header :contains ["List-Id"] "kernel-janitors.vger.kernel.org" {
    fileinto "Kernel.kernel-janitors";
    stop;
}

# rule:[Security]
if header :contains ["List-Id"] "list-id.securityfocus.com" {
    # Lists that go into security-bugtraq
    if header :contains ["List-Id"] "bugtraq.list-id.securityfocus.com" {
        fileinto "Security.security-bugtraq";
        stop;
    # Lists that go into securityfocus
    } elsif header :contains ["List-Id"] "security-basics.list-id.securityfocus.com" {
        fileinto "Security.securityfocus";
        stop;
    } elsif header :contains ["List-Id"] "secureshell.list-id.securityfocus.com" {
        fileinto "Security.securityfocus";
        stop;
    } elsif header :contains ["List-Id"] "pen-test.list-id.securityfocus.com" {
        fileinto "Security.securityfocus";
        stop;
    } elsif header :contains ["List-Id"] "webappsec.list-id.securityfocus.com" {
        fileinto "Security.securityfocus";
        stop;
    } elsif header :contains ["List-Id"] "wifisec.list-id.securityfocus.com" {
        fileinto "Security.securityfocus";
        stop;
    } elsif header :contains ["List-Id"] "honeypots.list-id.securityfocus.com" {
        fileinto "Security.securityfocus";
        stop;
    } elsif header :contains ["List-Id"] "focus-ids.list-id.securityfocus.com" {
        fileinto "Security.securityfocus";
        stop;
    } elsif header :contains ["List-Id"] "focus-virus.list-id.securityfocus.com" {
        fileinto "Security.securityfocus";
        stop;
    } elsif header :contains ["List-Id"] "loganalysis.list-id.securityfocus.com" {
        fileinto "Security.securityfocus";
        stop;
    } elsif header :contains ["List-Id"] "forensics.list-id.securityfocus.com" {
        fileinto "Security.securityfocus";
        stop;
    } elsif header :contains ["List-Id"] "focus-ms.list-id.securityfocus.com" {
        fileinto "Security.securityfocus";
        stop;
    } elsif header :contains ["List-Id"] "focus-apple.list-id.securityfocus.com" {
        fileinto "Security.securityfocus";
        stop;
    }
}

# rule:[Gentoo]
if header :contains ["List-Id"] "gentoo.org" {
    # Lists that go into gentoo-user
    if header :contains ["List-Id"] "gentoo-user.gentoo.org" {
        fileinto "Gentoo.gentoo-user";
        stop;
    } elsif header :contains ["List-Id"] "gentoo-amd64.gentoo.org" {
        fileinto "Gentoo.gentoo-user";
        stop;
    } elsif header :contains ["List-Id"] "gentoo-desktop.gentoo.org" {
        fileinto "Gentoo.gentoo-user";
        stop;
    } elsif header :contains ["List-Id"] "gentoo-hardened.gentoo.org" {
        fileinto "Gentoo.gentoo-user";
        stop;
    } elsif header :contains ["List-Id"] "gentoo-admin.gentoo.org" {
        fileinto "Gentoo.gentoo-user";
        stop;
    } elsif header :contains ["List-Id"] "gentoo-announce.gentoo.org" {
        # Special case for GLSAs: send them to gentoo-security
        if header :contains ["Subject"] "[ GLSA " {
            fileinto "Gentoo.gentoo-security";
            stop;
        }
        fileinto "Gentoo.gentoo-user";
        stop;
    # Lists that go into gentoo-dev
    } elsif header :contains ["List-Id"] "gentoo-dev.gentoo.org" {
        fileinto "Gentoo.gentoo-dev";
        stop;
    } elsif header :contains ["List-Id"] "gentoo-portage-dev.gentoo.org" {
        fileinto "Gentoo.gentoo-dev";
        stop;
    } elsif header :contains ["List-Id"] "gentoo-pms.gentoo.org" {
        fileinto "Gentoo.gentoo-dev";
        stop;
    } elsif header :contains ["List-Id"] "gentoo-qa.gentoo.org" {
        fileinto "Gentoo.gentoo-dev";
        stop;
    } elsif header :contains ["List-Id"] "gentoo-dev-announce.gentoo.org" {
        fileinto "Gentoo.gentoo-dev";
        stop;
    # Lists that go into gentoo-kernel
    } elsif header :contains ["List-Id"] "gentoo-kernel.gentoo.org" {
        fileinto "Gentoo.gentoo-kernel";
        stop;
    } elsif header :contains ["List-Id"] "gentoo-genkernel.gentoo.org" {
        fileinto "Gentoo.gentoo-kernel";
        stop;
    # Lists that go into gentoo-security
    } elsif header :contains ["List-Id"] "gentoo-security.gentoo.org" {
        fileinto "Gentoo.gentoo-security";
        stop;
    # Lists that go into gentoo-devhelp
    } elsif header :contains ["List-Id"] "gentoo-devhelp.gentoo.org" {
        fileinto "Gentoo.gentoo-devhelp";
        stop;
    # Lists that go into gentoo-project
    } elsif header :contains ["List-Id"] "gentoo-project.gentoo.org" {
        fileinto "Gentoo.gentoo-project";
        stop;
    } elsif header :contains ["List-Id"] "gentoo-soc.gentoo.org" {
        fileinto "Gentoo.gentoo-project";
        stop;
    }
    # Fallthrough
    fileinto "Gentoo";
    stop;
}

# rule:[MXE]
if header :contains ["List-Id"] "mingw-cross-env-list.nongnu.org" {
    fileinto "OSS.mxe";
    stop;
}


# Implicit keep