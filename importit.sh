images ()
{
	find . -name '*.cocot' |xargs cat |sed -n 's|.*images/\([^ ].*\)|\1|p' |awk '{print $1}'
	if [ -f templates/page.template ]
	then
		echo ketchup.jpeg
		echo mozchomp.gif
	fi
}

relevant ()
{
	BASE=$(echo $1 |sed 's/\.[^\.]*$//;s/-tn//')
	RELEVANT=$(cd ../images; echo $BASE*)
	for y in $RELEVANT
	do
		mkdir -p images/$(dirname $y)
		ln -f ../images/$y images/$y 2>>ERRORS && git add images/$y
	done
}

rm -rf .git *
git init
for i in ../patches/*
do
	images >imgs
	git am $i
	for i in $(diff imgs <(images) |awk '/>/ {print $2}')
	do
		relevant $i
	done
	EDITOR=true git commit --amend
done
