package Maypole::Config::YAML;

use strict;
use IO::File;
use Carp;
use YAML;

our $VERSION = '0.1';

=head1 NAME

Maypole::Config::YAML - Simple YAML style config for Maypole

=head1 SYNOPSIS

Inline config:

    # MyApp.pm
    package MyApp;

    use strict;
    use base qw(Apache::MVC Maypole::Config::YAML);

    MyApp->load_config;
    MyApp->setup(
        MyApp->config->{dsn},
        MyApp->config->{user},
        MyApp->config->{pass}
    );

    1;
    __DATA__
    --- #YAML:1.0
    dsn: 'dbi:Pg:dbname=myapp'
    user: myuser
    pass: mypass
    uri_base: 'http://127.0.0.1/myapp'
    template_root: '/home/sri/myapp/templates'
    rows_per_page: 10

Separate config file:

    # MyApp.pm
    package MyApp;

    use strict;
    use base qw(Apache::MVC Maypole::Config::YAML);

    MyApp->load_config('/etc/myapp.yaml');
    MyApp->setup(
        MyApp->config->{dsn},
        MyApp->config->{user},
        MyApp->config->{pass}
    );

    1;

    # /etc/myapp.yaml
    --- #YAML:1.0
    dsn: 'dbi:Pg:dbname=myapp'
    user: myuser
    pass: mypass
    uri_base: 'http://127.0.0.1/myapp'
    template_root: '/home/sri/myapp/templates'
    rows_per_page: 10

Advanced example:

    # MyApp.pm
    package MyApp;

    use strict;
    use base qw(Apache::MVC Maypole::Config::YAML
                Maypole::Authentication::Abstract);

    MyApp->load_config('/etc/myapp.yaml');
    MyApp->setup(
        MyApp->config->{dsn},
        MyApp->config->{user},
        MyApp->config->{pass}
    );

    sub authenticate {
        my ($self, $r) = @_;
        $r->public;
        if ($r->{action} eq 'edit') {
            $r->private;
            $r->{template} = 'login' unless $r->{user};
        }
    }

    1;

    # /etc/myapp.yaml
    --- #YAML:1.0
    dsn: 'dbi:Pg:dbname=myapp'
    user: myuser
    pass: mypass
    uri_base: 'http://127.0.0.1/myapp'
    template_root: '/home/sri/myapp/templates'
    rows_per_page: 10
    auth:
      user_class: MyApp::Customer
      session_class: Apache::Session::Postgres
      session_args:
        DataSource: 'dbi:Pg:dbname=myapp'
        UserName: myuser
        Password: mypass
        TableName: session
        Commit: 1

=head1 DESCRIPTION

Simple YAML style config for Maypole.

=cut

sub load_config {
    my ( $class, $path ) = @_;
    local $/;
    if ($path) {
        my $file = IO::File->new("< $path")
          or croak "Unable to open config file $path";
        $class->config(
            Load do { <$file> }
        );
    }
    else { $class->config( Load eval "package $class; <DATA>" ) }
}

=head1 AUTHOR

Sebastian Riedel, C<sri@oook.de>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify it under
the same terms as perl itself.

=cut

1;
