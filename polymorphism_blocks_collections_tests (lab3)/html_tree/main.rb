require './tag.rb'
require './tree.rb'

tree = Tree.new(
'<html>
<body>
    <form class="container">
        <h1>Авторизация</h1>
        <div>
            <div>что то</div>
            <div><div></div></div>
        </div>
        <div class="input__line">
            <span>Логин</span>
            <input id="login" type="text" />
        </div>
        <div class="input__line">
            <span>Пароль</span>
            <input id="password" type="password" />
        </div>
        <div class="input__line">
            <a href="https://site.com/forgot">Забыли пароль?</a>
        </div>
        <button>Войти</button>
    </form>
</body>
</html>'
)

def print_html_dfs(tree)
    tab_count = 0
    parents = []
    
    tree.each do |node|
        output = ''

        if !node.closing? && node.children_count > 0
            parents.push [node, node.children_count]
        end
        
        output += "#{'   ' * tab_count}#{node.opening_tag}#{node.content}"
        
        if !node.closing? && node.children_count == 0
            output += "#{node.closing_tag}"
        end

        puts output

        tab_count += 1 if !node.closing? && node.children_count > 0
        
        # обработка родителя (если есть)
        while parents.any? && parents.last[1] == 1 && node != parents.last[0]
            tab_count -= 1
            parent = parents.pop[0]
            puts "#{'   ' * tab_count}#{parent.closing_tag}"
        end

        parents.last[1] -= 1 if parents.any? && node != parents.last[0]
    end

    # остаточные теги
    parents.reverse.each do |parent, _|
        tab_count -= 1
        puts "#{'   ' * tab_count}#{parent.closing_tag}"
    end
end

# в этом обходе вывести html в прежней структуре не получится 
# (поэтому я тут и оставил всего один блок))) )
def print_opening_tags_bfs(tree)
    tree.bfs { |node| puts node.opening_tag }
end

puts 'HTML'
print_html_dfs(tree)

puts "\n\nОткрывающие теги:"
print_opening_tags_bfs(tree)

