if [ $(checkupdates | wc -l) -gt 0 ];
then
    presence="exists"
else
    presence="none"
fi

printf '{"alt": "%s"}\n' "$presence"
