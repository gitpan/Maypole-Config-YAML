use ExtUtils::MakeMaker;

WriteMakefile(
    NAME         => 'Maypole::Config::YAML',
    AUTHOR       => 'Sebastian Riedel (sri@oook.de)',
    PREREQ_PM    => { YAML => 0 },
    VERSION_FROM => 'YAML.pm'
);
