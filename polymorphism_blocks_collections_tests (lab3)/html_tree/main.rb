require './tag.rb'
require './tree.rb'

tree = Tree.new(
'<html>
<body>
    <form class="container">
        <h1>Авторизация</h1>
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
    tree.each(
        ->(node) {
            puts node.opening_tag
            puts node.content if !node.content.empty? && !node.content.nil?
        },
        ->(node) { puts node.closing_tag if !node.closing? }
    )
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

